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
  sops.secrets.password = {
    neededForUsers = true;
  };
  users = {
    mutableUsers = false;
    allowNoPasswordLogin = true;
    users = {
      nu = {
        isNormalUser = true;
        uid = 1000;
        # extraGroups = [ "input" "uinput" ];
        hashedPasswordFile = config.sops.secrets.password.path;
      };
    };
  };
}
