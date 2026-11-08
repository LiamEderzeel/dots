{ ... }:
{
  flake.modules.nixos.ai =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        opencode
      ];
    };
}
