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
            foreground = foreground;
            background = background;
            regular0 = regular0;
            regular1 = regular1;
            regular2 = regular2;
            regular3 = regular3;
            regular4 = regular4;
            regular5 = regular5;
            regular6 = regular6;
            regular7 = regular7;
            bright0 = bright0;
            bright1 = bright1;
            bright2 = bright2;
            bright3 = bright3;
            bright4 = bright4;
            bright5 = bright5;
            bright6 = bright6;
            bright7 = bright7;
          };
          scrollback = {
            lines = "5000";
          };
        };
      };
    })
  ];
}
