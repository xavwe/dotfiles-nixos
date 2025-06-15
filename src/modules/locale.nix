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
  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    glibcLocales = pkgs.glibcLocales.override {
      locales = [
        "en_US.UTF-8"
      ];
    };
  };
  # keymap
  # console.keyMap = "de";
}
