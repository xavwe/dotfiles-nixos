{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.ssh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use ssh";
    };
    daemon = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable SSH daemon on port 22";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.ssh.daemon.enable {
      services.openssh = {
        enable = true;
        ports = [22];
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          KbdInteractiveAuthentication = false;
        };
      };
    })
    (lib.mkIf config.modules.fzf.enable {
      home-manager.users.nu = {...}: {
        services.ssh-agent.enable = true;
        programs.ssh = {
          enable = true;
          matchBlocks = {
            homelab = {
              hostname = "192.168.178.110";
              user = "xaver_adm";
              extraOptions = {
                AddKeysToAgent = "yes";
                IdentityFile = "~/.ssh/homelab";
              };
            };
            vps = {
              hostname = "195.15.206.239";
              user = "root";
              extraOptions = {
                AddKeysToAgent = "yes";
                IdentityFile = "~/.ssh/infomaniak";
              };
            };
            "github.com" = {
              extraOptions = {
                AddKeysToAgent = "yes";
                IdentityFile = "~/.ssh/github";
              };
            };
            "codeberg.org" = {
              extraOptions = {
                AddKeysToAgent = "yes";
                IdentityFile = "~/.ssh/codeberg";
              };
            };
          };
        };
      };
    })
  ];
}
