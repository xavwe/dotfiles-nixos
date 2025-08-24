{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.espanso = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use espanso";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.espanso.enable {
      home-manager.users.nu = {...}: {
        services.espanso = {
          enable = true;
          waylandSupport = true;
          x11Support = false;
          matches = {
            base = {
              matches = [
                {
                  trigger = ":time";
                  replace = "{{time}}";
                }
                {
                  trigger = ":date";
                  replace = "{{date}}";
                }
              ];
            };
            global_vars = {
              global_vars = [
                {
                  name = "time";
                  type = "date";
                  params = {format = "%H:%M";};
                }
                {
                  name = "date";
                  type = "date";
                  params = {format = "%Y-%m-%d";};
                }
              ];
            };
          };
        };
      };
    })
  ];
}
