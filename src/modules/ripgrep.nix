# alias grep to rg
{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.ripgrep = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use ripgrep";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.ripgrep.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          ripgrep
        ];
      };
    })
  ];
}
