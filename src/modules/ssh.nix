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
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.fzf.enable {
      home-manager.users.nu = {...}: {
        services.ssh-agent.enable = true;
        programs.ssh = {
          enable = true;
          extraConfig = ''
            Host homelab
              HostName 192.168.178.110
              User xaver_adm

            Host vps
              HostName 195.15.206.239
              User ubuntu

            Host github.com
              AddKeysToAgent yes
              IdentityFile ~/.ssh/github

            Host codeberg.org
              AddKeysToAgent yes
              IdentityFile ~/.ssh/codeberg
          '';
        };
      };
    })
  ];
}
