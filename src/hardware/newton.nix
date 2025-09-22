{
  config,
  lib,
  pkgs,
  modulesPath,
  nixos-hardware,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-intel
  ];

  #security.tpm2.enable = true;
  #security.tpm2.pkcs11.enable = true;
  #security.tpm2.tctiEnvironment.enable = true;
  #users.users.nu.extraGroups = [ "tss" ];

  boot = {
    # Bootloader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "sr_mod"
      ];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  sops.secrets."nas/username" = {};
  sops.secrets."nas/password" = {};
  sops.templates."nas-credentials".content = ''
    username=${config.sops.placeholder."nas/username"}
    password=${config.sops.placeholder."nas/password"}
  '';

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "size=3G"
        "mode=755"
      ];
    };

    "/mnt/public" = {
      device = "//192.168.178.2/public";
      fsType = "cifs";
      options = [
        "credentials=${config.sops.templates."nas-credentials".path}"
        "rw"
        "vers=2.0"
        "gid=1000"
        "uid=1000"
      ];
    };

    "/mnt/home" = {
      device = "//192.168.178.2/home";
      fsType = "cifs";
      options = [
        "credentials=${config.sops.templates."nas-credentials".path}"
        "rw"
        "vers=2.0"
        "gid=1000"
        "uid=1000"
      ];
    };

    "/mnt/photo" = {
      device = "//192.168.178.2/photo";
      fsType = "cifs";
      options = [
        "credentials=${config.sops.templates."nas-credentials".path}"
        "rw"
        "vers=2.0"
        "gid=1000"
        "uid=1000"
      ];
    };

    "/mnt/video" = {
      device = "//192.168.178.2/video";
      fsType = "cifs";
      options = [
        "credentials=${config.sops.templates."nas-credentials".path}"
        "rw"
        "vers=2.0"
        "gid=1000"
        "uid=1000"
      ];
    };

    "/mnt/music" = {
      device = "//192.168.178.2/music";
      fsType = "cifs";
      options = [
        "credentials=${config.sops.templates."nas-credentials".path}"
        "rw"
        "vers=2.0"
        "gid=1000"
        "uid=1000"
      ];
    };
  };

  disko.devices = {
    disk = {
      nvme2n1 = {
        device = "/dev/nvme2n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "boot";
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              label = "root";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                mountpoint = "/mnt/btrfs";
                subvolumes = {
                  "@nixos-home" = {
                    mountpoint = "/home/nu";
                    mountOptions = ["subvol=@nixos-home" "compress=zstd" "noatime"];
                  };
                  "@nixos-nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["subvol=@nixos-nix" "compress=zstd" "noatime"];
                  };
                  "@nixos-swap" = {
                    mountpoint = "/swap";
                    swap.swapfile.size = "32G";
                  };
                  "@nixos-log" = {
                    mountpoint = "/var/log";
                    mountOptions = ["subvol=@nixos-log" "compress=zstd" "noatime"];
                  };
                  "@ollama-models" = {
                    mountpoint = "/var/lib/ollama/models";
                    mountOptions = ["subvol=@ollama-models" "compress=zstd" "noatime"];
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  #networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.wakeOnLan.enable = true;

  # Use systemd-networkd and systemd-resolved
  networking.useNetworkd = true;
  systemd.network.enable = true;
  systemd.network.links."10-enp6s0" = {
    matchConfig.Name = "enp6s0";
    linkConfig.WakeOnLan = "magic";
  };

  # Ensure WOL is enabled at boot and persist through power cycles
  systemd.services.enable-wol = {
    description = "Enable Wake-on-LAN for enp6s0";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.ethtool}/bin/ethtool -s enp6s0 wol g";
    };
  };
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
    dnsovertls = "true";
    fallbackDns = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
  };
  networking.resolvconf.enable = false;
  systemd.network.networks."enp6s0" = {
    matchConfig.Name = "enp6s0";
    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;
      DNS = [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
      ];
      #IPForward = true;
    };
    linkConfig = {
      RequiredForOnline = "routable"; # Wait for network-online.target until interface is routable
    };
  };
  networking.nameservers = [
    "1.1.1.1#one.one.one.one"
    "1.0.0.1#one.one.one.one"
  ];
  systemd.network.wait-online.anyInterface = true; # Consider network online if any interface is online
  networking.firewall.enable = true; # Enable firewall
  services.timesyncd.enable = true; # Enable systemd timesyncd service for time synchronization

  sops.age.keyFile = "/home/nu/.config/sops/age/keys.txt";

  # Set graphDriverName to btrfs
  virtualisation.containers.storage.settings = lib.mkIf config.modules.podman.enable {
    storage = {
      driver = "btrfs";
      graphroot = "/mnt/btrfs/@container";
      runroot = "/run/containers/storage";
      options.overlay.mountopt = "nodev,metacopy=on";
    };
  };

  hardware = {
    graphics.enable = true;
    graphics.extraPackages = with pkgs; [
      vpl-gpu-rt
      intel-media-driver
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };
  boot.extraModprobeConfig = "options kvm_intel nested=1";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  environment.systemPackages = [
    config.boot.kernelPackages.cpupower
    config.boot.kernelPackages.turbostat
    pkgs.smartmontools
    pkgs.lm_sensors
    pkgs.ethtool
  ];

  services.syncthing.settings = lib.mkIf config.modules.syncthing.enable {
    devices = {
      #"device1" = {id = "DEVICE-ID-GOES-HERE";};
      #"device2" = {id = "DEVICE-ID-GOES-HERE";};
      "phone" = {
        id = "LQOQG7N-J7RQKEX-S55F0D3-ZRORR4N-ASH4HUG-UYX3RFS-HNQYYWO-5KG6BQK";
      };
    };
    folders = {
      "book" = {
        # Name of folder in Syncthing, also the folder ID
        path = "/mnt/btrfs/@book"; # Which folder to add to Syncthing
        devices = ["phone"]; # Which devices to share the folder with
      };
      "projects" = {
        # Name of folder in Syncthing, also the folder ID
        path = "/mnt/btrfs/@projects"; # Which folder to add to Syncthing
        devices = ["phone"]; # Which devices to share the folder with
      };
    };
  };

  services.ollama.acceleration = lib.mkIf config.modules.ollama.enable false;

  # Set ownership of ollama models directory
  systemd.tmpfiles.rules = lib.mkIf config.modules.ollama.enable [
    "d /var/lib/ollama/models 0755 ollama ollama -"
    "Z /var/lib/ollama/models - ollama ollama - -"
  ];

  hardware.printers = {
    ensurePrinters = [
      {
        name = "hp-color-laserjet";
        location = "Home";
        deviceUri = "ipp://192.168.178.24";
        model = "drv:///sample.drv/generic.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
    ensureDefaultPrinter = "hp-color-laserjet";
  };
}
