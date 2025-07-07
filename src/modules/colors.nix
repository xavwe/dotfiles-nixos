{
  lib,
  config,
  ...
}:
with lib; let
  colorSchemes = {
    darknight = {
      foreground = "d8d8d8";
      background = "181818";
      cursor = "d8d8d8";
      mouse_background = "181818";
      mouse_foreground = "d8d8d8";
      regular0 = "181818";
      regular1 = "e57474";
      regular2 = "8ccf7e";
      regular3 = "e5c76b";
      regular4 = "67b0e8";
      regular5 = "c47fd5";
      regular6 = "6cbfbf";
      regular7 = "d8d8d8";
      bright0 = "282828";
      bright1 = "ff8484";
      bright2 = "9cfc8e";
      bright3 = "ffdc7b";
      bright4 = "77c0ff";
      bright5 = "d48fff";
      bright6 = "77dfdf";
      bright7 = "ffffff";
    };
  };
in {
  options = {
    modules.colors = {
      theme = mkOption {
        type = types.str;
        default = "darknight";
        description = "The color scheme to use.";
      };
    };
    colors = mkOption {
      type = types.attrs;
      description = "The color scheme attribute set.";
    };
  };

  config = {
    colors = colorSchemes.${config.modules.colors.theme};
  };
}
