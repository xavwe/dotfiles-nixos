#  WARNING: requires sudo to work without bugs; writeShellScriptBin workaround does not work for all commands
{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.nh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use nh";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.nh.enable {
      programs.nh = {
        enable = true;
      };
      environment.systemPackages = lib.mkIf (config.modules.sudo.enable == false) [
        (pkgs.writeShellScriptBin "sudo" "doas $@")
      ];
      environment.sessionVariables = {
        FLAKE = "/home/nu/.dotfiles/src";
      };
    })
  ];
}
