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

  environment.corePackages = with pkgs; [
    acl
    attr
    bashInteractive # bash with ncurses support
    bzip2
    coreutils-full
    cpio
    curl
    diffutils
    findutils
    gawk
    getent
    getconf
    gnugrep
    gnupatch
    gnused
    gnutar
    gzip
    xz
    less
    libcap
    ncurses
    netcat
    mkpasswd
    procps
    su
    time
    util-linux
    which
    zstd

    gcc
  ];

  home-manager.users.nu = {
    home = {
      # default applications
      packages = with pkgs; [
        jq
        yq

        fd
        ripgrep

        parallel-full
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
