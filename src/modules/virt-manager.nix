# doas virsh net-autostart default
{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.virt-manager = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use virt-manager";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.virt-manager.enable {
      programs.dconf.enable = true;
      environment.systemPackages = with pkgs; [
        virt-manager
        virt-viewer
        spice
        spice-gtk
        spice-protocol
        win-virtio
        win-spice
      ];
      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [
              (pkgs.OVMF.override {
                secureBoot = true;
                tpmSupport = true;
              }).fd
            ];
          };
        };
      };
      users.groups.libvirtd.members = ["nu"];
      virtualisation.spiceUSBRedirection.enable = true;
      programs.virt-manager.enable = true;
      services.spice-vdagentd.enable = true;
    })
  ];
}
