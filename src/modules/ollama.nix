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
      services.ollama = {
        enable = true;
        loadModels = ["gpt-oss:20b"];
        package = pkgs.fix.ollama;
      };
    })
  ];
}
