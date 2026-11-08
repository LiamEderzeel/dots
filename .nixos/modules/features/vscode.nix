{ ... }:
{
  flake.modules.nixos.vscode =
    { pkgs-unstable, ... }:
    {
      # nixpkgs 26.05 fails to patch vscode 1.144.0 (missing bundled ripgrep)
      environment.systemPackages = [ pkgs-unstable.vscode ];
    };
}
