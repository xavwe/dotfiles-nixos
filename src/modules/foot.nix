# TODO: font jebrains not here but in font jetbrians enable aulso option terminal-default and there if foot then foot default and if kityy then kitty default
{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.foot = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use foot";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.foot.enable {
      programs.foot = {
        enable = true;
        settings = {
          main = {
            font = "JetBrainsMono Nerdfont:size=13";
          };
          colors = with config.colors; {
            foreground = base05;
            background = base00;
          };
          scrollback = {
            lines = "5000";
          };
        };
      };
    })
  ];
}
