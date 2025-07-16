{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.scrcpy = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable scrcpy for Android screen mirroring";
    };
  };

  config = lib.mkIf config.modules.scrcpy.enable {
    environment.systemPackages = with pkgs; [
      scrcpy
      android-tools # for adb
    ];

    # Enable udev rules for Android devices
    services.udev.packages = with pkgs; [
      android-udev-rules
    ];

    # Add user to adbusers group for ADB access
    users.users.nu.extraGroups = ["adbusers"];

    home-manager.users.nu = {
      xdg.desktopEntries.scrcpy = {
        name = "scrcpy";
        exec = "${pkgs.scrcpy}/bin/scrcpy";
        comment = "Display and control Android devices";
        categories = ["Utility" "System"];
        icon = "phone";
      };
    };
  };
}