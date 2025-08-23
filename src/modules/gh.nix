{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.gh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use GitHub CLI (gh)";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.gh.enable {
      home-manager.users.nu = {...}: {
        programs.gh = {
          enable = true;
          settings = {
            git_protocol = "ssh";
            pager = "less";
          };
          extensions = with pkgs; [
            gh-poi
            gh-dash
            gh-markdown-preview
          ];
        };
      };
    })
  ];
}
