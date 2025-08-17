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
  # temporary hosts entries for testing xavwe.dev locally
  networking.hosts = {
    "127.0.0.1" = ["test.xavwe.dev" "traefik.xavwe.dev" "rss.xavwe.dev"];
  };

  documentation = {
    enable = true;
    nixos.enable = true;
  };

  # shell aliases
  home-manager.users.nu = {
    home = {
      # default applications
      packages = with pkgs; [
        util-linux
        vim
        wget
        curl
        gcc
        jq
        yq
        fd
        ripgrep
      ];
      shellAliases =
        lib.optionalAttrs config.modules.foot.enable {
          ssh = "TERM=xterm-256color ssh";
        }
        // {
          open = "xdg-open";
          ll = "ls -al";
          doas = "doas --";

          diff = "diff --color=auto";
          grep = "grep --color=auto";
          ip = "ip --color=auto";
          dmesg = "dmesg --color=always";
          ls = "ls --color=auto";
          watch = "watch --color";

          weather = "curl -s wttr.in | less";
        };
    };
  };
}