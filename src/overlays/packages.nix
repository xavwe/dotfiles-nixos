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

  extract = inputs.extract.packages.x86_64-linux.default;
}
