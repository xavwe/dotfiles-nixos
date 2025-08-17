{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  home-manager,
  overlays,
  sops-nix,
  ...
}: {
  options.modules.hotspot = {
    enable = lib.mkEnableOption "WiFi hotspot functionality";

    gui = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable GUI application for hotspot management";
    };
  };

  config = lib.mkIf config.modules.hotspot.enable {
    # Install hotspot packages
    home-manager.users.nu = {
      home.packages = with pkgs;
        [
          # Command-line hotspot tools
          hostapd # IEEE 802.11 AP and IEEE 802.1X/WPA/WPA2/EAP Authenticator
          dnsmasq # DNS forwarder and DHCP server
          iw # Wireless tools for Linux
          iptables # Firewall and NAT rules

          # Feature-rich hotspot creator with CLI support
          linux-wifi-hotspot # Both GUI and CLI interface
        ]
        ++ lib.optionals config.modules.hotspot.gui [
          # GUI-only tools (when gui is enabled)
          # linux-wifi-hotspot already provides GUI when installed
        ];
    };

    # Don't enable dnsmasq globally - create_ap will handle it when needed
    # services.dnsmasq.enable = true;

    # Allow hotspot traffic through firewall (using nftables like virt-manager)
    networking.firewall = {
      allowedTCPPorts = [53 67]; # DNS and DHCP
      allowedUDPPorts = [53 67 68]; # DNS, DHCP server and client

      # Allow DNS/DHCP traffic from hotspot interfaces
      extraInputRules = ''
        # Allow DNS/DHCP from hotspot interfaces
        iifname "ap0" tcp dport 53 accept
        iifname "ap0" udp dport 53 accept
        iifname "ap0" udp dport 67 accept
        iifname "wlo1" tcp dport 53 accept
        iifname "wlo1" udp dport 53 accept
        iifname "wlo1" udp dport 67 accept
      '';

      # Allow hotspot traffic forwarding (similar to virt-manager setup)
      extraForwardRules = ''
        # Allow hotspot traffic forwarding
        iifname "ap0" oifname != "ap0" accept
        iifname != "ap0" oifname "ap0" ct state { related, established } accept
        iifname "wlo1" oifname != "wlo1" accept
        iifname != "wlo1" oifname "wlo1" ct state { related, established } accept

        # NAT for hotspot traffic specifically to ethernet interface
        oifname "enp6s0" ip saddr 192.168.12.0/24 masquerade
        oifname "enp6s0" ip saddr 192.168.4.0/24 masquerade

        # Allow traffic from hotspot to ethernet
        iifname "ap0" oifname "enp6s0" accept
        iifname "enp6s0" oifname "ap0" ct state { related, established } accept
      '';
    };

    # Add user to netdev group for wireless interface management
    users.groups.netdev = {};

    # Enable IP forwarding for hotspot functionality
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };

    # Don't force disable NetworkManager - let user choose their network management
    # Just ensure we have the tools available for hotspot creation
    # networking.networkmanager.enable is handled by profiles
    # networking.wireless.enable is handled by profiles

    # Add udev rules for wireless interface access
    services.udev.extraRules = ''
      # Allow users in netdev group to control wireless interfaces
      SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="?*", ATTR{type}=="1", KERNEL=="wlan*", GROUP="netdev", MODE="0660"
    '';
  };
}
