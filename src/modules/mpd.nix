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
  services.mpd = {
    enable = true;
    extraConfig = ''
      user "nu"
      bind_to_address "localhost"
      port "6600"
      restore_paused "yes"
      audio_output {
        type    "pipewire"
        name    "PipeWire Sound Server"
      }
      audio_output {
        type    "fifo"
        name    "my_fifo"
        path    "/tmp/mpd.fifo"
        format  "44100:16:2"
      }
    '';
    musicDirectory = "/home/nu/music";
  };
  services.mpd.user = "nu";
  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.nu.uid}";
  };
}
