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
        enable = false;
      };

      shell = {
        default = "zsh";
        zsh = {
          enable = true;
        };
      };

      browser = {
        enable = false;
      };

      terminal-emulator = {
        enable = false;
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
        enable = false;
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
      scrcpy.enable = false;
      nginx.enable = false;
      gh.enable = false;
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
      distrobox.enable = false;
      tldr.enable = true;
      pass.enable = true;
      gpg.enable = true;
      newsboat.enable = false;
      nvd.enable = false;
      nix-output-monitor.enable = false;
      claude-code.enable = false;
      zathura = {
        enable = false;
        default = false;
      };
      libreoffice = {
        enable = false;
        default = false;
      };
      dark-mode.enable = false;
      starship.enable = false;
      virt-manager.enable = false;
      wakatime.enable = true;
    };
  };
}
