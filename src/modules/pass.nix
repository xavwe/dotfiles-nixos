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
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          (pass.withExtensions (exts: [exts.pass-otp]))
        ];
      };
    })

    (lib.mkIf (config.modules.firefox.enable && config.modules.pass.enable) {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          passff-host
          gnupg
          pinentry-gtk2
        ];
        home.file.".gnupg/gpg-agent.conf".text = ''
          pinentry-program ${pkgs.pinentry-gtk2}/bin/pinentry-gtk-2
        '';
        home.file.".mozilla/native-messaging-hosts/passff.json".source = "${pkgs.passff-host}/lib/mozilla/native-messaging-hosts/passff.json";
      };
    })
  ];
}
