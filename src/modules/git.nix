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
          userName = "Xaver Wenhart";
          userEmail = "git@xavwe.dev";
          aliases = lib.mkIf config.modules.git.aliases.yolo {
            yolo = "!git commit -m \"$(curl -s https://whatthecommit.com/index.txt)\"";
          };
          difftastic.color = "auto";
          extraConfig = {
            column = {
              ui = "always";
            };
            color = {
              ui = "auto";
            };
            core = {
              editor = "nvim";
              fsmonitor = true;
              autocrlf = "input";
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
            branch = {
              sort = "-committerdate";
            };
            tag = {
              sort = "version:refname";
            };
            init = {
              defaultBranch = "main";
            };
            diff = {
              algorithm = "histogram";
              colorMoved = "plain";
              mnemonicPrefix = true;
              renames = true;
              guitool = "nvimdiff2";
            };
            push = {
              default = "simple";
              autoSetupRemote = true;
              followTags = true;
            };
            help = {
              autocorrect = "prompt";
            };
            commit = {
              verbose = true;
            };
            pull = {
              rebase = true;
            };
            merge = {
              conflictstyle = "zdiff3";
            };
            status = {
              short = true;
              relativePaths = false;
              branch = true;
              showStash = true;
            };
            url = {
              "git@github.com:".insteadOf = "gh:";
            };
            rerere = {
              enabled = true;
              autoupdate = true;
            };
            fetch = {
              all = true;
              writeCommitGraph = true;
            };
            rebase = {
              updateRefs = true;
              autosquash = true;
            };
          };
        };
      };
    })
  ];
}