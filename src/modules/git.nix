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
    username = lib.mkOption {
      type = lib.types.str;
      default = "xavwe";
      description = "Git username";
    };
    mail = lib.mkOption {
      type = lib.types.str;
      default = "xaver.wenhart@proton.me";
      description = "Git email";
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
          userName = config.modules.git.username;
          userEmail = config.modules.git.mail;
          aliases = lib.mkIf config.modules.git.aliases.yolo {
            yolo = "!git commit -m \"$(curl -s https://whatthecommit.com/index.txt)\"";
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
