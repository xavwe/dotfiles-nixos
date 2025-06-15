{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.zsh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use zsh";
    };
    default = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Make zsh default";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.zsh.enable {
      home-manager.users.nu = {...}: {
        programs.zsh = {
          enable = true;
          dotDir = ".config/zsh";
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          initContent = lib.concatLines [
            (lib.optionalString config.modules.just.enable ''
              eval "$(just --completions zsh)"
            '')
            (lib.optionalString config.modules.jujutsu.enable ''
              source <(COMPLETE=zsh jj)
            '')
            (lib.optionalString config.modules.starship.enable ''
              eval "$(starship init zsh)"
            '')
            ''
              zstyle ':completion:*' completer _expand_alias _complete _ignored
              precmd() {
                print -Pn "\e]0;$(fc -ln -1)\a"
              }
              screenshot() {
                IMG=~/screenshot/$(date +%Y-%m-%d_%H-%m-%s).png && grim -g "$(slurp)" $IMG && wl-copy < $IMG
              }
            ''
          ];
          profileExtra = lib.mkIf config.modules.hyprland.enable ''
            Hyprland
          '';
          history = {
            path = "$ZDOTDIR/.zsh_history";
            size = 10000;
            save = 10000;
          };
        };
        programs.direnv.enableZshIntegration = lib.mkIf config.modules.direnv.enable true;
      };
      users.users.nu.ignoreShellProgramCheck = true;
    })

    (lib.mkIf config.modules.zsh.default {
      users.users.nu.shell = pkgs.zsh;
    })
  ];
}
