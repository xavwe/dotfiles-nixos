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
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts-emoji
      unifont
    ];
    fontconfig = {
      defaultFonts = {
        #serif = ["Liberation Serif" "Vazirmatn"];
        #sansSerif = ["Ubuntu" "Vazirmatn"];
        monospace = ["JetBrainsMono Nerd Font"];
      };
    };
  };
}
