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
      package = pkgs.fix.ncmpcpp.override {visualizerSupport = true;};
      mpdMusicDir = "/home/nu/music/";
      settings = {
        mpd_host = "localhost";
        mpd_port = "6600";
        visualizer_data_source = "/tmp/mpd.fifo";
        visualizer_output_name = "my_fifo";
        visualizer_in_stereo = "yes";
        visualizer_type = "ellipse";
        visualizer_look = "●▮";
      };
    };
  };
}
