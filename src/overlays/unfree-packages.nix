# This overlay adds an 'unfree' attribute that points to a nixpkgs instance
# with unfree packages allowed.
{inputs}: final: _prev: {
  unfree = import inputs.nixpkgs {
    system = final.system;
    config.allowUnfree = true;
  };
}
