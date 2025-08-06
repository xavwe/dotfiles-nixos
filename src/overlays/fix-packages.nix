{inputs}: final: prev: {
  fix = {
    ncmpcpp = prev.ncmpcpp.overrideAttrs (oldAttrs: {
      nativeBuildInputs =
        (oldAttrs.nativeBuildInputs or [])
        ++ [
          prev.pkg-config
        ];
      buildInputs =
        (oldAttrs.buildInputs or [])
        ++ [
          prev.boost.dev
        ];
      configureFlags =
        (oldAttrs.configureFlags or [])
        ++ [
          "--with-boost=${prev.boost.dev}"
          "--with-boost-libdir=${prev.boost.out}/lib"
        ];
      # Ensure boost headers are found during configure
      preConfigure = ''
        export BOOST_ROOT=${prev.boost.dev}
        export BOOST_INCLUDEDIR=${prev.boost.dev}/include
        export BOOST_LIBRARYDIR=${prev.boost.out}/lib
        ${oldAttrs.preConfigure or ""}
      '';
    });
    
    ollama = prev.ollama.overrideAttrs (oldAttrs: rec {
      version = "0.11.2";
      src = prev.fetchFromGitHub {
        owner = "ollama";
        repo = "ollama";
        rev = "v${version}";
        hash = "sha256-NZaaCR6nD6YypelnlocPn/43tpUz0FMziAlPvsdCb44=";
        fetchSubmodules = true;
      };
    });
  };
}
