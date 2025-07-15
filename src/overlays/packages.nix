{inputs}: final: prev: {
  btop-gpu = prev.stdenv.mkDerivation rec {
    pname = "btop";
    version = "1.4.4";

    src = final.fetchFromGitHub {
      owner = "aristocratos";
      repo = "btop";
      rev = "v${version}";
      sha256 = "sha256-4H9UjewJ7UFQtTQYwvHZL3ecPiChpfT6LEZwbdBCIa0=";
    };

    nativeBuildInputs = [prev.makeWrapper];
    buildInputs = [
      prev.ncurses
      prev.pciutils
    ];

    makeFlags = ["GPU_SUPPORT=true"];

    installPhase = ''
      mkdir -p $out/bin
      cp bin/btop $out/bin/
    '';
  };

  ccusage = final.buildNpmPackage rec {
    pname = "ccusage";
    version = "15.3.1";

    src = final.fetchzip {
      url = "https://registry.npmjs.org/ccusage/-/ccusage-${version}.tgz";
      hash = "sha256-y3Vg8BIeBYUrGCijs9MZe5mDrhuTzmlUOju8HZct/FU=";
    };

    npmDepsHash = "sha256-3n0JlwuPlp7NKRbTvvxdzbS5u/R/07XatIEKr7S9Y64=";
    forceEmptyCache = true;

    postPatch = ''
      cat > package-lock.json << 'EOF'
{
  "name": "ccusage",
  "version": "15.3.1",
  "lockfileVersion": 3,
  "requires": true,
  "packages": {
    "": {
      "name": "ccusage",
      "version": "15.3.1"
    }
  }
}
EOF
    '';

    nativeBuildInputs = with final; [ makeWrapper ];

    dontNpmBuild = true;
    dontNpmInstall = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/lib/node_modules/ccusage
      cp -r * $out/lib/node_modules/ccusage/
      makeWrapper ${final.nodejs}/bin/node $out/bin/ccusage \
        --add-flags "$out/lib/node_modules/ccusage/bin/ccusage.js"
      runHook postInstall
    '';

    meta = with final.lib; {
      description = "A CLI tool for analyzing Claude Code usage from local JSONL files";
      homepage = "https://github.com/ryoppippi/ccusage";
      license = licenses.mit;
      platforms = platforms.all;
      mainProgram = "ccusage";
    };
  };

  extract = inputs.extract.packages.x86_64-linux.default;
}
