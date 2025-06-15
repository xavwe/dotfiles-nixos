{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.podman = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use podman";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.podman.enable {
      virtualisation = {
        containers.enable = true;
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
          autoPrune = {
            enable = true;
            dates = "weekly";
            flags = [
              "--filter=until=24h"
              "--filter=label!=important"
            ];
          };
        };
        oci-containers = {
          backend = "podman";
        };
      };
      users.users.nu = {
        linger = true;
      };

      users.groups.podman.members = ["nu"];
      environment.systemPackages = with pkgs; [podman-compose slirp4netns fuse-overlayfs];

      boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;

      # Automatically start containers on boot
      systemd.services.podman-autostart = {
        enable = true;
        after = ["podman.service"];
        wantedBy = ["multi-user.target"];
        description = "Automatically start containers with --restart=always tag";
        serviceConfig = {
          Type = "idle";
          User = "nu";
          ExecStartPre = ''${pkgs.coreutils}/bin/sleep 1'';
          ExecStart = ''/run/current-system/sw/bin/podman start --all --filter restart-policy=always'';
        };
      };
    })
  ];
}
