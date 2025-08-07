{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.sunshine = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Sunshine for game streaming";
    };
  };

  config = lib.mkIf config.modules.sunshine.enable {
    environment.systemPackages = with pkgs; [
      sunshine
    ];

    # Enable the Sunshine service
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
    };

    # Open firewall ports for Sunshine
    networking.firewall = {
      allowedTCPPorts = [
        47984 # HTTPS Web UI
        47989 # HTTP Web UI
        48010 # RTSP
      ];
      allowedUDPPorts = [
        47998 # Video
        47999 # Control
        48000 # Audio
      ];
    };

    # Add user to input group for controller access
    users.users.nu.extraGroups = ["input"];

    home-manager.users.nu = {
      xdg.desktopEntries.sunshine = {
        name = "Sunshine";
        exec = "${pkgs.sunshine}/bin/sunshine";
        comment = "Game streaming host for Moonlight";
        categories = ["Game" "Network"];
        icon = "sunshine";
      };
    };
  };
}
