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
            foreground = base06;
            background = base00;

            urls = base0D;

            regular0 = base00;
            regular1 = base08;
            regular2 = base0B;
            regular3 = base0A;
            regular4 = base0D;
            regular5 = base0E;
            regular6 = base0C;
            regular7 = base06;

            bright0 = base01;
            bright1 = base08;
            bright2 = base0B;
            bright3 = base0A;
            bright4 = base0D;
            bright5 = base0E;
            bright6 = base0C;
            bright7 = base04;
          };
          scrollback = {
            lines = "5000";
          };
          key-bindings = {
            spawn-terminal = "Super+Shift+q";
          };
        };
      };
    })
  ];
}
