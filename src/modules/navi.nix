{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  sops-nix,
  ...
}: {
  options.modules.navi = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use navi";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.navi.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          navi
          fzf
        ];
        home.file.".config/navi/config.yaml".text = ''
          finder:
            command: fzf
          client:
            tealdeer: true
          cheats:
            paths:
              - /home/nu/.local/share/navi/cheats
        '';
        home.file.".local/share/navi/cheats/default/misc/default.cheat".text = ''
          % misc

          # project file stats
          nix run nixpkgs#cloc -- . --exclude-dir=<exclude-dir>

          $ exclude-dir: --- --header "example: .git,node_modules"

          # weather
          curl -s wttr.in | $PAGER

          # public ip
          curl -s ifconfig.co | $PAGER
        '';
      };
    })
  ];
}
