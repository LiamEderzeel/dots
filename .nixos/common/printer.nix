{ config, pkgs,inputs, ... }:
{
  services.printing = {
    enable = true;
    drivers = with pkgs; [ brlaser ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
