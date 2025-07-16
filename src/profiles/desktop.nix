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

    modules = {
      # gui
      firefox.enable = true;
      firefox.default = true;
      hyprland.enable = true;
      hyprland.xwayland.enable = true;
      foot.enable = true;
      zathura.enable = true;
      zathura.default = true;
      libreoffice.enable = true;
      libreoffice.default = true;

      # cli
      neovim.enable = true;
      neovim.default = true;
      neovim.manpager = true;
      jujutsu.enable = true;
      fastfetch.enable = true;
      just.enable = true;
      fzf.enable = true;
      btop.enable = true;
      direnv.enable = true;
      chafa.enable = true;
      chafa.default = true;
      zoxide.enable = true;
      zoxide.default = true;
      mpv.enable = true;
      mpv.default = true;
      yazi.enable = true;
      yazi.default = true;
      extract.enable = true;
      podman.enable = true;
      distrobox.enable = true;
      tldr.enable = true;
      pass.enable = true;
      gpg.enable = true;
      newsboat.enable = true;
      nvd.enable = true;
      nix-output-monitor.enable = true;
      claude-code.enable = true;

      # system
      dark-mode.enable = true;
      starship.enable = true;
      virt-manager.enable = true;
      wakatime.enable = true;
      colors.theme = "darknight";
    };
  };
}
