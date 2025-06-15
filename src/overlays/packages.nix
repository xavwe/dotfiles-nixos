{inputs}: final: prev: {
  btop-gpu = prev.stdenv.mkDerivation rec {
    pname = "btop";
    version = "1.4.3";

    src = final.fetchFromGitHub {
      owner = "aristocratos";
      repo = "btop";
      rev = "v${version}";
      sha256 = "10g4m14cniw4blnazw0rs92fkgxhhri8zcvg3kcz2xgnc4day7g3";
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

  extract = inputs.extract.packages.x86_64-linux.default;
}
