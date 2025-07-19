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
      sops.secrets.wakatime = {
        owner = "nu";
        group = "users";
        mode = "0400";
      };

      home-manager.users.nu = {
        pkgs,
        lib,
        ...
      }: {
        home.activation.wakatimeConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
                    $DRY_RUN_CMD mkdir -p $HOME
                    if [[ -f ${config.sops.secrets.wakatime.path} ]]; then
                      API_KEY=$(cat ${config.sops.secrets.wakatime.path})
                      $DRY_RUN_CMD cat > $HOME/.wakatime.cfg << EOF
          [settings]
          api_key = $API_KEY
          api_url = https://hackatime.hackclub.com/api/hackatime/v1
          heartbeat_rate_limit_seconds = 30
          EOF
                    fi
        '';
      };
    })
  ];
}
