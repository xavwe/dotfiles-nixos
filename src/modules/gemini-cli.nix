{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  home-manager,
  overlays,
  sops-nix,
  ...
}: {
  environment.systemPackages = with pkgs; [
    gemini-cli
  ];
  home-manager.users.nu = {...}: {
    home.file.".gemini/settings.json".text = ''
      {
        "theme": "GitHub",
        "selectedAuthType": "oauth-personal",
        "usageStatisticsEnabled": false
      }
    '';
  };
}
