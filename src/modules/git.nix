{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.git = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use git";
    };
    aliases.yolo = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable git yolo";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.git.enable {
      home-manager.users.nu = {...}: {
        programs.git = {
          enable = true;
          userName = "xavwe";
          userEmail = "xaver.wenhart@proton.me";
          aliases = lib.mkIf config.modules.git.aliases.yolo {
            yolo = "!git commit -m \"$(curl -s https://whatthecommit.com/index.txt)\"";
            sync = "!git remote prune origin && git branch -vv | awk '/: gone]/{print $1}' | xargs -r git branch -D";
          };
          difftastic.color = "auto";
          extraConfig = {
            color = {
              ui = "auto";
            };
            core = {
              editor = "nvim";
            };
            commit = {
              gpgsign = true;
            };
            gpg = {
              format = "ssh";
            };
            user = {
              signingkey = "~/.ssh/github";
            };
          };
        };
      };
    })
  ];
}
