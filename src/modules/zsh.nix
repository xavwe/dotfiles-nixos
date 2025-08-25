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
      home-manager.users.nu = {...} @ hmArgs: let
        hmConfig = hmArgs.config;
      in {
        programs.zsh = {
          enable = true;
          dotDir = "${hmConfig.xdg.configHome}/zsh";
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          historySubstringSearch.enable = true;
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

                # Check if last command was git clone without --recursive or --bare
                local last_cmd=$(fc -ln -1 | xargs)
                if [[ "$last_cmd" =~ ^git[[:space:]]+clone[[:space:]] ]]; then
                  if ! ([[ "$last_cmd" =~ --recursive ]] && [[ "$last_cmd" =~ --bare ]]); then
                    echo "Info: Consider using 'git clone --recursive --bare'"
                  fi
                fi

                # Add newline if needed (after commands, empty enters, or interrupts)
                [[ "$PROMPT_NEEDS_NEWLINE" == true ]] && echo

                PROMPT_NEEDS_NEWLINE=true
              }

              # Handle Control+C interrupts
              TRAPINT() {
                return $(( 128 + $1 ))
              }

              screenshot() {
                IMG=~/screenshot/$(date +%Y-%m-%d_%H-%m-%s).png && grim -g "$(slurp)" $IMG && wl-copy < $IMG
              }

              # OSC-7 escape sequence for terminal working directory tracking
              function osc7-pwd() {
                emulate -L zsh # also sets localoptions for us
                setopt extendedglob
                local LC_ALL=C
                printf '\e]7;file://%s%s\e\' $HOST ''${PWD//(#m)([^@-Za-z&-;_~])/%''${(l:2::0:)$(([##16]#MATCH))}}
              }
              function chpwd-osc7-pwd() {
                (( ZSH_SUBSHELL )) || osc7-pwd
              }
              add-zsh-hook -Uz chpwd chpwd-osc7-pwd

              # newline after each command
              # see precmd, preexec
              PROMPT_NEEDS_NEWLINE=false
              clear() {
                PROMPT_NEEDS_NEWLINE=false
                command clear
              }

              # vim mode
              bindkey -v
              bindkey -M viins '^?' backward-delete-char
            ''
          ];
          profileExtra = lib.mkIf config.modules.hyprland.enable ''
            # Auto-start Hyprland if not already running
            if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
              exec Hyprland
            fi
          '';
          history = {
            path = "${hmConfig.xdg.configHome}/zsh/.zsh_history";
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
