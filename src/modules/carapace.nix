{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.carapace = {
    enable = lib.mkEnableOption "Claude Code configuration";
  };

  config = lib.mkIf config.modules.carapace.enable {
    home-manager.users.nu = {...}: {
      home.packages = with pkgs; [
        carapace
      ];
      programs.carapace = {
        enable = true;
        enableZshIntegration = config.modules.zsh.enable;
      };
    };
  };
}
