{inputs}: final: _prev: {
  stable =
    import inputs.nixpkgs-stable {
      system = "x86_64-linux";
      config.allowUnfree = false;
    }
    // {
      unfree = import inputs.nixpkgs-stable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    };
}
