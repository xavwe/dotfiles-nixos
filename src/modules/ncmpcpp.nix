# ncmpcpp extra file
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
  home-manager.users.nu = {pkgs, ...}: {
    programs.ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override {visualizerSupport = true;};
      mpdMusicDir = "/home/nu/music/";
      settings = {
        mpd_host = "localhost";
        mpd_port = "6600";
      };
    };
  };
}