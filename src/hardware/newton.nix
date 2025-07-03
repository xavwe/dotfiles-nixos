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
      device = "/dev/disk/by-uuid/3a517161-86cc-4d8b-a190-6611f05049d7";
      fsType = "btrfs";
      options = [
        "subvol=@nixos"
        "compress=zstd"
        "noatime"
      ];
    };

    "/swap" = {
      device = "/dev/disk/by-uuid/3a517161-86cc-4d8b-a190-6611f05049d7";
      fsType = "btrfs";
      options = [
        "subvol=@swap"
        "compress=zstd"
        "noatime"
      ];
    };

    "/home/nu/.dotfiles" = {
      device = "/dev/disk/by-uuid/3a517161-86cc-4d8b-a190-6611f05049d7";
      fsType = "btrfs";
      options = [
        "subvol=@dotfiles-nixos"
        "compress=zstd"
        "noatime"
      ];
    };

    "/home/nu/notes" = {
      device = "/dev/disk/by-uuid/3a517161-86cc-4d8b-a190-6611f05049d7";
      fsType = "btrfs";
      options = [
        "subvol=@notes"
        "compress=zstd"
        "noatime"
      ];
    };

    "/home/nu/music" = {
      device = "/dev/disk/by-uuid/3a517161-86cc-4d8b-a190-6611f05049d7";
      fsType = "btrfs";
      options = [
        "subvol=@music"
        "compress=zstd"
        "noatime"
      ];
    };

    "/home/nu/images" = {
      device = "/dev/disk/by-uuid/3a517161-86cc-4d8b-a190-6611f05049d7";
      fsType = "btrfs";
      options = [
        "subvol=@images"
        "compress=zstd"
        "noatime"
      ];
    };

    "/home/nu/projects" = {
      device = "/dev/disk/by-uuid/3a517161-86cc-4d8b-a190-6611f05049d7";
      fsType = "btrfs";
      options = [
        "subvol=@projects"
        "compress=zstd"
        "noatime"
      ];
    };

    "/home/nu/.ssh" = {
      device = "/dev/disk/by-uuid/3a517161-86cc-4d8b-a190-6611f05049d7";
      fsType = "btrfs";
      options = [
        "subvol=@ssh"
        "compress=zstd"
        "noatime"
      ];
    };

    "/mnt/btrfs" = {
      device = "/dev/disk/by-uuid/3a517161-86cc-4d8b-a190-6611f05049d7";
      fsType = "btrfs";
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

    "/boot" = {
      device = "/dev/disk/by-uuid/3E72-1921";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  #networking.useDHCP = lib.mkDefault true;
  networking.interfaces.enp6s0.wakeOnLan.enable = true;

  # Use systemd-networkd and systemd-resolved
  networking.useNetworkd = true;
  systemd.network.enable = true;
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
      # WakeOnLan = "magic";
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
  ];
}