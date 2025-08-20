{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  home-manager,
  overlays,
  sops-nix,
  ...
}: {
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts-emoji
      unifont
      literata
    ];
    fontconfig = {
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        serif = ["Literata"];
        #sansSerif = ["Ubuntu" "Vazirmatn"];
        monospace = ["JetBrainsMono Nerd Font"];
      };
    };
  };
}
