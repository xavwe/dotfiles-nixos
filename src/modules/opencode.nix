{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.opencode = {
    enable = lib.mkEnableOption "Claude Code configuration";
  };

  config = lib.mkIf config.modules.opencode.enable {
    home-manager.users.nu = {...}: {
      home.packages = with pkgs; [
        opencode
      ];
    };
  };
}
