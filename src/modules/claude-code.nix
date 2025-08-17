{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: let
  cfg = config.modules.claude-code;
in {
  options.modules.claude-code = {
    enable = lib.mkEnableOption "Claude Code configuration";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.nu = {...}: {
      home.packages = with pkgs; [
        unfree.claude-code
        ccusage
        claude-trace
      ];

      # programs.bash.shellAliases.commit = "claude --dangerously-skip-permissions -p \"/commit\"";
      # programs.zsh.shellAliases.commit = "claude --dangerously-skip-permissions -p \"/commit\"";

      home.file.".claude/settings.json".text = builtins.toJSON {
        env = {
          DISABLE_TELEMETRY = "1";
          DISABLE_AUTOUPDATER = "1";
        };
        includeCoAuthoredBy = false;
      };
    };
  };
}
