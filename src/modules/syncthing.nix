{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.syncthing = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use syncthing";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.syncthing.enable {
      networking.firewall.allowedTCPPorts = [8384 22000];
      networking.firewall.allowedUDPPorts = [22000 21027];

      services = {
        syncthing = {
          enable = true;
          group = "users";
          user = "nu";
          relay.enable = false;
          dataDir = "/mnt/syncthing";
          configDir = "/home/nu/.config/syncthing";
          overrideDevices = true;
          overrideFolders = true;
          extraFlags = ["--no-default-folder"]; # Don't create default ~/Sync folder
          guiAddress = "127.0.0.1:8384";
          settings = {
            gui = {
              user = "nu";
              password = "password";
            };
          };
        };
      };
    })
  ];
}
