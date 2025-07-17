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
    username = lib.mkOption {
      type = lib.types.str;
      default = "xavwe";
      description = "Jujutsu username";
    };
    mail = lib.mkOption {
      type = lib.types.str;
      default = "xaver.wenhart@proton.me";
      description = "Jujutsu email";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.jujutsu.enable {
      environment.systemPackages = with pkgs; [
        jujutsu
      ];

      home-manager.users.nu = {...}: {
        home.file.".config/jj/config.toml".text = ''
          "$schema" = "https://jj-vcs.github.io/jj/latest/config-schema.json"

          [user]
          name = "${config.modules.jujutsu.username}"
          email = "${config.modules.jujutsu.mail}"

          [ui]
          default-command = [ "log" ]
        '';
      };
    })
  ];
}
