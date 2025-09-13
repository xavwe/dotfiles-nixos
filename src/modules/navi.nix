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
        home.file.".local/share/navi/cheats/default/default.cheat".text = ''
          % first cheat

          # print something
          echo "My name is <name>!"

          $ name: whoami
        '';
      };
    })
  ];
}
