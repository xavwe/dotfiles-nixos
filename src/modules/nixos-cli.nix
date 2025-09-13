{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  sops-nix,
  ...
}: {
  options.modules.nixos-cli = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use nixos-cli";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.nixos-cli.enable {
      services.nixos-cli = {
        enable = true;
        # config = {
        #   # Whatever settings desired.
        # };
      };
    })
  ];
}
