{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.traefik = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Traefik reverse proxy";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.traefik.enable {
      # SOPS secret for Cloudflare credentials
      sops.secrets.cloudflare = {
        sopsFile = ../secrets.yaml;
        owner = "traefik";
        group = "traefik";
        mode = "0400";
      };

      services.traefik = {
        enable = true;

        staticConfigOptions = {
          # Entry points
          entryPoints = {
            web = {
              address = ":80";
              http.redirections.entrypoint = {
                to = "websecure";
                scheme = "https";
                permanent = true;
              };
            };
            websecure = {
              address = ":443";
            };
          };

          # Providers
          providers = {
            file = {
              directory = "/etc/traefik/dynamic";
              watch = true;
            };
          };

          # Certificate resolver for Let's Encrypt with Cloudflare DNS challenge
          certificatesResolvers = {
            cloudflare = {
              acme = {
                email = "admin@xavwe.dev";
                storage = "${config.services.traefik.dataDir}/acme.json";
                dnsChallenge = {
                  provider = "cloudflare";
                  resolvers = ["1.1.1.1:53" "1.0.0.1:53"];
                };
              };
            };
          };

          # API and dashboard
          api = {
            dashboard = true;
            insecure = false;
          };

          # Logging
          log = {
            level = "DEBUG";
          };
          accessLog = {};
        };
      };

      # Create dynamic configuration file
      environment.etc."traefik/dynamic/routes.yml" = {
        text = ''
          http:
            routers:
              nginx:
                rule: "Host(`test.xavwe.dev`)"
                service: "nginx"
                entryPoints:
                  - "websecure"
                tls:
                  certResolver: "cloudflare"

              traefik-dashboard:
                rule: "Host(`traefik.xavwe.dev`)"
                service: "api@internal"
                entryPoints:
                  - "websecure"
                tls:
                  certResolver: "cloudflare"

            services:
              nginx:
                loadBalancer:
                  servers:
                    - url: "http://127.0.0.1:8080"
        '';
        mode = "0644";
      };

      # Ensure traefik data directory exists
      systemd.tmpfiles.rules = [
        "d /var/lib/traefik 0755 traefik traefik - -"
        "f /var/lib/traefik/acme.json 0600 traefik traefik - -"
      ];

      # Firewall configuration
      networking.firewall = {
        allowedTCPPorts = [80 443];
      };

      # User and group
      users.users.traefik = {
        isSystemUser = true;
        group = "traefik";
        home = "/var/lib/traefik";
        createHome = true;
      };
      users.groups.traefik = {};

      # Configure environment variables for Cloudflare
      systemd.services.traefik = {
        serviceConfig = {
          EnvironmentFile = config.sops.secrets.cloudflare.path;
        };
      };
    })
  ];
}
