{
  lib,
  config,
  ...
}: {
  options = {
    modules.colors = {
      theme = lib.mkOption {
        type = lib.types.str;
        default = "darknight";
        description = "The color scheme to use.";
      };
    };
    colors = lib.mkOption {
      type = lib.types.attrs;
      description = "The color scheme attribute set.";
    };
  };

  config = {
    colors = config.colorSchemes.${config.modules.colors.theme};
  };
}
