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
    unfree.claude-code
    ccusage
  ];

  systemd.services.claude-mcp-setup = {
    description = "Setup Claude MCP server";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      Type = "oneshot";
      User = "nu";
      ExecStart = "${pkgs.unfree.claude-code}/bin/claude mcp add -s user claude claude mcp serve";
      RemainAfterExit = true;
    };
  };
}
