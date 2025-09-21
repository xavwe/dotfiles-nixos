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
      rofi.enable = true;
      foot.enable = true;
      zathura.enable = true;
      zathura.default = true;
      libreoffice.enable = true;
      libreoffice.default = true;
      calibre.enable = false;
      scrcpy.enable = true;
      sunshine.enable = true;
      legcord.enable = false;
      ags.enable = false;

      # cli
      neovim.enable = true;
      neovim.default = true;
      neovim.pager = true;
      jujutsu.enable = true;
      gh.enable = true;
      tree.enable = true;
      fastfetch.enable = true;
      just.enable = true;
      fzf.enable = true;
      btop.enable = true;
      direnv.enable = true;
      chafa.enable = true;
      chafa.default = true;
      zoxide.enable = true;
      zoxide.default = false;
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
      opencode.enable = true;
      ollama.enable = true;
      graphite.enable = false;
      nixos-cli.enable = true;
      navi.enable = true;

      # system
      espanso.enable = true;
      carapace.enable = true;
      dark-mode.enable = true;
      printing.enable = true;
      starship.enable = true;
      virt-manager.enable = true;
      wakatime.enable = true;
      colors.theme = "darknight";
      hotspot.enable = true;
      syncthing.enable = false;
      ssh.daemon.enable = true;

      # web services
      traefik.enable = true;
      nginx.enable = true;
      #miniflux.enable = true;
    };
  };
}