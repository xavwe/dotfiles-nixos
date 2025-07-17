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
  networking.nftables.enable = true;

  # Additional firewall rules for Traefik/Nginx setup
  networking.firewall = lib.mkMerge [
    # Block direct access to Nginx port 8080 from external sources
    (lib.mkIf config.modules.nginx.enable {
      extraInputRules = ''
        # Block external access to Nginx port 8080
        ip saddr != 127.0.0.1 tcp dport 8080 drop
      '';
    })
  ];
}
