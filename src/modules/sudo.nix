{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.sudo = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use sudo";
    };
  };
  config = lib.mkIf config.modules.sudo.enable {
    security = {
      sudo = {
        enable = true;
      };
    };
    users.users.nu = {
      extraGroups = lib.mkBefore ["wheel"];
    };
  };
}
