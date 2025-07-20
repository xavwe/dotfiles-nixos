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
    environment.systemPackages = with pkgs; [
      # Command-line hotspot tools
      hostapd              # IEEE 802.11 AP and IEEE 802.1X/WPA/WPA2/EAP Authenticator
      dnsmasq              # DNS forwarder and DHCP server
      iw                   # Wireless tools for Linux
      iptables             # Firewall and NAT rules
      
      # Feature-rich hotspot creator with CLI support
      linux-wifi-hotspot   # Both GUI and CLI interface
    ] ++ lib.optionals config.modules.hotspot.gui [
      # GUI-only tools (when gui is enabled)
      # linux-wifi-hotspot already provides GUI when installed
    ];

    # Don't enable dnsmasq globally - create_ap will handle it when needed
    # services.dnsmasq.enable = true;
    
    # Allow hotspot traffic through firewall
    networking.firewall = {
      allowedTCPPorts = [ 53 67 ];  # DNS and DHCP
      allowedUDPPorts = [ 53 67 68 ]; # DNS, DHCP server and client
    };

    # Add user to netdev group for wireless interface management
    users.groups.netdev = {};
    
    # Home manager configuration for shell aliases
    home-manager.users.nu = {
      home.shellAliases = lib.mkIf config.modules.hotspot.enable {
        # GUI application (if enabled)
        hotspot-gui = lib.mkIf config.modules.hotspot.gui "wihotspot-gui";
        
        # Main hotspot commands using create_ap from linux-wifi-hotspot
        hotspot-start = "sudo create_ap wlan0 eth0 MyHotspot password123";
        hotspot-stop = "sudo create_ap --stop wlan0";
        hotspot-status = "sudo create_ap --list-running";
        hotspot-clients = "sudo create_ap --list-clients wlan0";
        
        # Alternative: TUI interface 
        hotspot-tui = "wihotspot";
        
        # Advanced options
        hotspot-daemon = "sudo create_ap --daemon wlan0 eth0 MyHotspot password123";
        hotspot-no-internet = "sudo create_ap -n wlan0 MyHotspot password123";
        hotspot-hidden = "sudo create_ap --hidden wlan0 eth0 MyHotspot password123";
      };
    };

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