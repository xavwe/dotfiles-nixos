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
      firefox.enable = false;
      firefox.default = false;
      foot.enable = false;
      zathura.enable = false;
      zathura.default = false;
      libreoffice.enable = false;
      libreoffice.default = false;

      # cli
      neovim.enable = true;
      neovim.default = true;
      neovim.pager = true;
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
      distrobox.enable = false;
      tldr.enable = true;
      pass.enable = true;
      gpg.enable = true;
      newsboat.enable = false;

      # system
      dark-mode.enable = false;
      starship.enable = false;
      virt-manager.enable = false;
      wakatime.enable = true;
      colors.theme = "darknight";
    };
  };
}
