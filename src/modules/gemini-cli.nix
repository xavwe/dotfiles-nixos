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
  sops.secrets.gemini = {
    owner = "nu";
    mode = "0400";
  };
  environment.systemPackages = with pkgs; [
    (pkgs.writeShellScriptBin "gemini" ''
      export GEMINI_API_KEY="$(cat ${config.sops.secrets.gemini.path})"
      exec ${pkgs.gemini-cli}/bin/gemini "$@"
    '')
  ];
  home-manager.users.nu = {...}: {
    home.file.".gemini/settings.json".text = ''
      {
        "theme": "GitHub",
        "selectedAuthType": "gemini-api-key"",
        "usageStatisticsEnabled": false
      }
    '';
  };
}
