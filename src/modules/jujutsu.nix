{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.jujutsu = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use jujutsu";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.jujutsu.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          jujutsu
          difftastic
        ];
        home.file.".config/jj/config.toml".text = ''
          "$schema" = "https://jj-vcs.github.io/jj/latest/config-schema.json"

          [user]
          name = "Xaver Wenhart"
          email = "git@xavwe.dev"

          [signing]
          behavior = "own"
          backend = "ssh"
          key = "~/.ssh/github"

          [ui]
          default-command = [ "log" ]
          diff-formatter = ["difft", "--color=always", "$left", "$right"]
        '';
      };
    })
  ];
}
