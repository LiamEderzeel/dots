{ ... }:
{
  flake.modules.nixos.vscode =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.vscode ];
    };
}
