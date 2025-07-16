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

    nativeBuildInputs = with final; [makeWrapper];

    dontNpmBuild = true;
    dontNpmInstall = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/lib/node_modules/ccusage
      cp -r * $out/lib/node_modules/ccusage/
      makeWrapper ${final.nodejs}/bin/node $out/bin/ccusage \
        --add-flags "$out/lib/node_modules/ccusage/dist/index.js"
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

  claude-trace = final.stdenv.mkDerivation rec {
    pname = "claude-trace";
    version = "1.0.3";

    src = final.fetchzip {
      url = "https://registry.npmjs.org/@mariozechner/claude-trace/-/claude-trace-${version}.tgz";
      hash = "sha256-cbTb37Th0t182CMRVNdyHbquzEHLcn0/WMdeRscxKuM=";
    };

    nativeBuildInputs = with final; [makeWrapper];

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/lib/node_modules/@mariozechner/claude-trace
      cp -r * $out/lib/node_modules/@mariozechner/claude-trace/
      
      # Create a Node.js wrapper that can be executed by the interceptor
      cat > $out/lib/node_modules/@mariozechner/claude-trace/dist/claude-node-wrapper.js << 'EOF'
#!/usr/bin/env node
const { spawn } = require("child_process");

// This wrapper allows the interceptor to work with the bash-wrapped Claude CLI
// by spawning the actual bash script with the proper environment

const claudePath = "${final.unfree.claude-code}/bin/claude";
const args = process.argv.slice(2);

const child = spawn("bash", [claudePath, ...args], {
  env: {
    ...process.env,
    DISABLE_AUTOUPDATER: '1'
  },
  stdio: "inherit",
  cwd: process.cwd(),
});

child.on("exit", (code) => process.exit(code || 0));
child.on("error", (error) => {
  console.error("Error launching Claude:", error);
  process.exit(1);
});
EOF
      
      chmod +x $out/lib/node_modules/@mariozechner/claude-trace/dist/claude-node-wrapper.js
      
      # Patch cli.js to use our Node.js wrapper instead of the bash script
      sed -i 's|const claudePath = getClaudeAbsolutePath();|const claudePath = path.join(__dirname, "claude-node-wrapper.js");|g' \
        $out/lib/node_modules/@mariozechner/claude-trace/dist/cli.js
      
      # Create wrapper that properly handles ES modules
      makeWrapper ${final.nodejs}/bin/node $out/bin/claude-trace \
        --add-flags "$out/lib/node_modules/@mariozechner/claude-trace/dist/cli.js" \
        --set NODE_PATH "$out/lib/node_modules"
      
      runHook postInstall
    '';

    meta = with final.lib; {
      description = "Record all your interactions with Claude Code as you develop your projects";
      homepage = "https://github.com/badlogic/lemmy/tree/main/apps/claude-trace";
      license = licenses.mit;
      platforms = platforms.all;
      mainProgram = "claude-trace";
    };
  };

  extract = inputs.extract.packages.x86_64-linux.default;
}
