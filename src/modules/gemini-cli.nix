{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  sops-nix,
  ...
}: {
  options.modules.gemini-cli = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use gemini-cli";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.gemini-cli.enable {
      sops.secrets.gemini = {
        owner = "nu";
        mode = "0400";
      };
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          (pkgs.writeShellScriptBin "gemini" ''
            export GEMINI_API_KEY="$(cat ${config.sops.secrets.gemini.path})"
            exec ${pkgs.gemini-cli}/bin/gemini "$@"
          '')
        ];
        home.file.".gemini/settings.json".text = ''
          {
            "theme": "GitHub",
            "selectedAuthType": "gemini-api-key",
            "usageStatisticsEnabled": false
          }
        '';
      };
    })
  ];
}
