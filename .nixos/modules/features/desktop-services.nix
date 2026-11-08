{ ... }:
{
  flake.modules.nixos.desktop-services = {
    hardware.bluetooth.enable = true;

    services = {
      gvfs.enable = true;
      udisks2.enable = true;
      dbus.enable = true;
      blueman.enable = true;
      flatpak.enable = true;
    };
  };
}
