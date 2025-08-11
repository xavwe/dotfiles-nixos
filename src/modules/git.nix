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
            sync = "!f() { git remote prune origin; to_delete=(); for branch in $(git branch --format='%(refname:short)' | grep -v '^main$'); do if ! git ls-remote --exit-code --heads origin $branch >/dev/null 2>&1; then to_delete+=(\"$branch\"); fi; done; if [ ${#to_delete[@]} -eq 0 ]; then echo 'No local branches to sync (all exist on origin)'; else echo 'The following branches do not exist on origin and will be deleted:'; printf '  %s\\n' \"${to_delete[@]}\"; echo; read -p 'Delete these branches? (y/N): ' confirm; if [[ $confirm =~ ^[Yy]$ ]]; then for branch in \"${to_delete[@]}\"; do git branch -D \"$branch\"; done; echo 'Branches deleted.'; else echo 'Sync cancelled.'; fi; fi; }; f";
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
