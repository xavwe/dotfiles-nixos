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
      environment.systemPackages = with pkgs; [
        jujutsu
      ];

      home-manager.users.nu = {...}: {
        home.file.".config/jj/config.toml".text = ''
          "$schema" = "https://jj-vcs.github.io/jj/latest/config-schema.json"

          [user]
          name = "Xaver Wenhart"
          email = "xaver.wenhart@proton.me"

          [ui]
          default-command = [ "log" ]
        '';
      };
    })
  ];
}
