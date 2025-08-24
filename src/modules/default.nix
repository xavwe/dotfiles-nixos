{
  inputs,
  outputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    # gui
    ./firefox.nix
    ./hyprland.nix
    ./rofi.nix
    ./foot.nix
    ./zathura.nix
    ./libreoffice.nix
    ./calibre.nix
    ./pavucontrol.nix
    ./helvum.nix
    ./scrcpy.nix
    ./sunshine.nix
    ./legcord.nix

    # cli
    ./graphite.nix
    ./tree.nix
    ./neovim.nix
    ./doas.nix
    ./sudo.nix
    ./jujutsu.nix
    ./git.nix
    ./gh.nix
    ./fastfetch.nix
    ./just.nix
    ./fzf.nix
    ./btop.nix
    ./direnv.nix
    ./chafa.nix
    ./zoxide.nix
    ./mpv.nix
    ./yazi.nix
    ./extract.nix
    ./distrobox.nix
    ./tldr.nix
    ./pass.nix
    ./gpg.nix
    ./newsboat.nix
    ./nix-output-monitor.nix
    ./nvd.nix
    ./links-browser.nix
    ./gemini-cli.nix
    ./rsync.nix
    ./ncmpcpp.nix
    ./mpc.nix
    ./claude-code.nix
    ./ollama.nix

    # shell
    ./zsh.nix
    ./bash.nix

    # system
    ./ags.nix
    ./pipewire.nix
    ./espanso.nix
    ./printing.nix
    ./system.nix
    ./kanata.nix
    ./wl-clipboard.nix
    ./dark-mode.nix
    ./colors.nix
    ./ssh.nix
    ./starship.nix
    ./podman.nix
    ./virt-manager.nix
    ./wakatime.nix
    ./nix-sops.nix
    ./linux.nix
    ./user.nix
    ./nix.nix
    ./firewall.nix
    ./xdg.nix
    ./font.nix
    ./locale.nix
    ./misc.nix
    ./mpd.nix
    ./traefik.nix
    ./nginx.nix
    ./miniflux.nix
    ./hotspot.nix
    ./syncthing.nix
  ];
}
