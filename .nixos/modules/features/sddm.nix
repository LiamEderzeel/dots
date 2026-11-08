{ ... }:
{
  flake.modules.nixos.sddm =
    { pkgs, ... }:
    {
      services.displayManager.sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;
        extraPackages = with pkgs; [
          sddm-astronaut
          kdePackages.qt5compat
          kdePackages.qtmultimedia
        ];
        theme = "where_is_my_sddm_theme";
        wayland.enable = true;
      };

      services.gnome.gnome-keyring.enable = true;
      security.pam.services.sddm.enableGnomeKeyring = true;
    };
}
