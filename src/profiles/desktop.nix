{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  sops-nix,
  ...
}: {
  config = {
    # hostname
    networking.hostName = "newton";

    dotfiles = {
      enable = true;
      locales = "en_US.UTF-8";
      theme = "darknight";

      window-manager = {
        enable = true;
        default = "hyprland";
        hyprland = {
          enable = true;
          xwayland = {
            enable = true;
          };
        };
      };

      shell = {
        default = "zsh";
        zsh = {
          enable = true;
        };
      };

      browser = {
        enable = true;
        default = "firefox";
        firefox = {
          enable = true;
        };
      };

      terminal-emulator = {
        enable = true;
        default = "foot";
        foot = {
          enable = true;
        };
      };

      editor = {
        enable = true;
        default = "neovim";
        neovim = {
          enable = true;
          manpager = true;
        };
      };

      container-engine = {
        enable = true;
        default = "podman";
        podman = {
          enable = true;
        };
      };

      reverse-proxy = {
        enable = true;
        default = "traefik";
        traefik = {
          enable = true;
        };
      };
    };

    # Keep old modules configuration for system-level modules not yet categorized
    modules = {
      colors.theme = "darknight";

      # Misc applications
      git = {
        enable = true;
        username = "xavwe";
        mail = "xaver.wenhart@proton.me";
      };
      jujutsu = {
        enable = true;
        username = "xavwe";
        mail = "xaver.wenhart@proton.me";
      };
      scrcpy.enable = true;
      nginx.enable = true;
      gh.enable = true;
      fastfetch.enable = true;
      just.enable = true;
      fzf.enable = true;
      btop.enable = true;
      direnv.enable = true;
      chafa = {
        enable = true;
        default = true;
      };
      zoxide = {
        enable = true;
        default = true;
      };
      mpv = {
        enable = true;
        default = true;
      };
      yazi = {
        enable = true;
        default = true;
      };
      extract.enable = true;
      distrobox.enable = true;
      tldr.enable = true;
      pass.enable = true;
      gpg.enable = true;
      newsboat.enable = true;
      nvd.enable = true;
      nix-output-monitor.enable = true;
      claude-code.enable = true;
      zathura = {
        enable = true;
        default = true;
      };
      libreoffice = {
        enable = true;
        default = true;
      };
      dark-mode.enable = true;
      starship.enable = true;
      virt-manager.enable = true;
      wakatime.enable = true;
    };
  };
}
