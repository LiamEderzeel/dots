{ ... }:
{
  flake.modules.nixos.communication =
    { pkgs-unstable, ... }:
    {
      environment.systemPackages = with pkgs-unstable; [
        ferdium
        discord
        slack
        telegram-desktop
        signal-desktop
        gajim
        teams-for-linux
        thunderbird
      ];
    };
}
