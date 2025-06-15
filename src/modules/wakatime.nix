{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  sops-nix,
  ...
}: {
  options.modules.wakatime = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use wakatime";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.wakatime.enable {
      sops.secrets."wakatime/key" = {};
      sops.secrets."wakatime/url" = {};
      home-manager.users.nu = {...}: {
        home.file.".wakatime.cfg.test".source = (pkgs.formats.ini {}).generate ".wakatime.cfg" {
          settings = {
            #api_url = api;
            #api_key = builtins.readFile onfig.sops.secrets."wakatime/key".path;
            heartbeat_rate_limit_seconds = 30;
          };
        };
      };
    })
  ];
}
