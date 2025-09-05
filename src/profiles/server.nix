{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  sops-nix,
  ...
}: {
  config = {
    # hostname
    networking.hostName = "newton";

    modules = {
      # cli
      neovim.enable = true;
      neovim.default = true;
      neovim.pager = true;
      gh.enable = true;
      fzf.enable = true;
      btop.enable = true;
      direnv.enable = true;
      gpg.enable = true;
      opencode.enable = true;

      # system
      starship.enable = true;
      ssh.daemon.enable = true;

      # web services
      traefik.enable = true;
      plausible.enable = true;
      #nginx.enable = true;
      #miniflux.enable = true;
    };
  };
}
