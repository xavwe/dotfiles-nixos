# TODO: font jebrains not here but in font jetbrians enable aulso option terminal-default and there if zen-browser then zen-browser default and if kityy then kitty default
{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.zen-browser = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use zen-browser";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.zen-browser.enable {
      home-manager.users.nu = {...}: {
        programs.zen-browser.enable = true;
      };
    })
  ];
}
