{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.plausible = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Plausible Analytics";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.plausible.enable {
      # SOPS secret for Plausible secret key
      sops.secrets.plausible-secret-key-base = {
        sopsFile = ../secrets.yaml;
        owner = "plausible";
        group = "plausible";
        mode = "0400";
      };

      services.plausible = {
        enable = true;

        server = {
          baseUrl = "https://analytics.xavwe.dev";
          secretKeybaseFile = config.sops.secrets.plausible-secret-key-base.path;
          port = 8082;
        };

        database = {
          clickhouse = {
            setup = true;
          };
          postgres = {
            setup = true;
          };
        };
      };

      # Ensure plausible user and group exist
      users.users.plausible = {
        isSystemUser = true;
        group = "plausible";
        home = "/var/lib/plausible";
        createHome = true;
      };
      users.groups.plausible = {};
    })
  ];
}
