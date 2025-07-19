# Declarative VM networking configuration
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
        extraConfig = ''
          # Ensure default network auto-starts
          unix_sock_group = "libvirtd"
          unix_sock_ro_perms = "0777"
          unix_sock_rw_perms = "0770"
          auth_unix_ro = "none"
          auth_unix_rw = "none"
        '';
      };

      # Declaratively define and auto-start the default network
      systemd.services.libvirtd-default-network = {
        description = "Auto-start libvirt default network";
        wantedBy = ["multi-user.target"];
        after = ["libvirtd.service"];
        requires = ["libvirtd.service"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          # Define the default network if it doesn't exist
          if ! ${pkgs.libvirt}/bin/virsh net-list --all | grep -q "default"; then
            ${pkgs.libvirt}/bin/virsh net-define ${pkgs.writeText "default-network.xml" ''
            <network>
              <name>default</name>
              <uuid>f6f0d97d-01ad-4feb-b143-6a31c260589a</uuid>
              <forward mode='nat'>
                <nat>
                  <port start='1024' end='65535'/>
                </nat>
              </forward>
              <bridge name='virbr0' stp='on' delay='0'/>
              <mac address='52:54:00:12:34:56'/>
              <ip address='192.168.122.1' netmask='255.255.255.0'>
                <dhcp>
                  <range start='192.168.122.2' end='192.168.122.254'/>
                </dhcp>
              </ip>
            </network>
          ''}
          fi

          # Start the network if it's not running
          if ! ${pkgs.libvirt}/bin/virsh net-list | grep -q "default"; then
            ${pkgs.libvirt}/bin/virsh net-start default
          fi

          # Enable autostart for the network
          ${pkgs.libvirt}/bin/virsh net-autostart default
        '';
      };
      users.groups.libvirtd.members = ["nu"];
      virtualisation.spiceUSBRedirection.enable = true;
      programs.virt-manager.enable = true;
      services.spice-vdagentd.enable = true;

      # Firewall rules for VM networking
      networking.firewall = {
        trustedInterfaces = ["virbr0"];
        extraInputRules = ''
          # Allow DHCP for VMs
          iifname "virbr0" udp dport { 67, 68 } accept
          # Allow DNS for VMs
          iifname "virbr0" tcp dport 53 accept
          iifname "virbr0" udp dport 53 accept
        '';
        extraForwardRules = ''
          # Allow VM traffic forwarding
          iifname "virbr0" oifname != "virbr0" accept
          iifname != "virbr0" oifname "virbr0" ct state { related, established } accept
        '';
      };
    })
  ];
}
