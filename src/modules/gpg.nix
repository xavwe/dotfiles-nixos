{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.gpg = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use gpg";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.gpg.enable {
      services.pcscd.enable = true;
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    })
  ];
}
