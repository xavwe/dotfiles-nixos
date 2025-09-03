{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.starship = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use starship";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.starship.enable {
      home-manager.users.nu = {...}: {
        programs.starship = {
          enable = true;
          settings = {
            add_newline = false;
            #command_timeout = 1300;
            #scan_timeout = 50;
            format = "$directory$custom$git_branch$direnv$shell_in_shell\n$character";
            character = {
              success_symbol = "[❯](bold fg:#9ECE6A)";
              error_symbol = "[❯](bold fg:#F5758D)";
              vimcmd_symbol = "[❮](bold fg:#9ECE6A)";
            };
            time = {
              format = " [$time]($style)";
              disabled = false;
            };
            custom.jj = {
              when = "jj root";
              symbol = "󱗆 ";
              format = "[$symbol]($style)";
              style = "fg:#7DCFFF";
            };
            git_branch = {
              symbol = "󰊢 ";
              format = "[$symbol]($style)";
              style = "fg:#E0AF68";
            };
            direnv = {
              disabled = false;
              symbol = "󰌪 ";
              format = "[$loaded]($style) ";
              allowed_msg = "";
              not_allowed_msg = "";
              denied_msg = "";
              loaded_msg = "󰌪 ";
              unloaded_msg = "󱋙 ";
              style = "fg:#8C73B9";
            };
            directory = {
              read_only = " ";
              read_only_style = "fg:#F3748C";
              style = "fg:#7AA2F7";
              format = "[$path]($style) [$read_only]($read_only_style)";
            };
            custom.distrobox = lib.mkIf config.modules.distrobox.enable {
              when = ''[[ -n "$DISTROBOX_ENTER_PATH" ]]'';
              symbol = " ";
              format = "[$symbol]($style)";
              style = "fg:#A8E4A0";
            };
            custom.shell_in_shell = {
              when = ''[[ $SHLVL -gt 2 ]] && ! [[ -n "$DISTROBOX_ENTER_PATH" ]]''; # +1 because of starship
              symbol = " ";
              format = "[$symbol]($style)";
              style = "fg:#7dcfff";
            };
          };
        };
      };
    })
  ];
}