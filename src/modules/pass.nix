{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.pass = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use pass";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.pass.enable {
      environment.systemPackages = with pkgs; [
        (pass.withExtensions (exts: [exts.pass-otp]))
      ];
    })

    (lib.mkIf (config.modules.firefox.enable && config.modules.pass.enable) {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          passff-host
          gnupg
          pinentry-curses
        ];
        home.file.".gnupg/gpg-agent.conf".text = ''
          pinentry-program ${pkgs.pinentry-curses}/bin/pinentry-curses
        '';
        home.file.".mozilla/native-messaging-hosts/passff.json".source = "${pkgs.passff-host}/lib/mozilla/native-messaging-hosts/passff.json";
      };
    })
  ];
}
