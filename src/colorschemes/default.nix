{
  config,
  pkgs,
  lib,
  ...
}: {
  options.colorSchemes = lib.mkOption {
    type = lib.types.attrs;
    description = "Collection of custom color schemes.";
    default = {};
  };

  config = {
    colorSchemes = {
      darknight = (import ./darknight.nix).colors;
      tokyonight = (import ./tokyonight.nix).colors;
    };
  };
}
