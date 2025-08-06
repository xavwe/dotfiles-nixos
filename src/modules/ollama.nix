{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.ollama = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use ollama";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.ollama.enable {
      users.users.ollama = {
        isSystemUser = true;
        group = "ollama";
        home = "/var/lib/ollama";
        createHome = true;
        description = "Ollama service user";
      };

      users.groups.ollama = {};

      services.ollama = {
        enable = true;
        #loadModels = ["gpt-oss:20b"];
        user = "ollama";
        group = "ollama";
        package = pkgs.fix.ollama;
        home = "/var/lib/ollama";
        models = "${config.services.ollama.home}/models";
      };
    })
  ];
}
