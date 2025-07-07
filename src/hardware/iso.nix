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
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  sops.age.keyFile = "/home/nu/.config/sops/age/keys.txt";

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
}
