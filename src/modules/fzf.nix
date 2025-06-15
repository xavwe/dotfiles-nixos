{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.fzf = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use fzf";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.fzf.enable {
      home-manager.users.nu = {...}: {
        programs.zsh.enable = true;
        programs.fzf = {
          enable = true;
          enableZshIntegration = lib.mkIf config.modules.zsh.enable true;
          enableBashIntegration = true;
        };
      };
    })
  ];
}
