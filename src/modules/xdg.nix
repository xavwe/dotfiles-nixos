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
  home-manager.users.nu = {
    xdg.enable = true;
    xdg.mimeApps.enable = true;
  };
  environment.sessionVariables = lib.mkMerge [
    {
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    }
  ];
}
