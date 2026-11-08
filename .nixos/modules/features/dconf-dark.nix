{ ... }:
{
  flake.modules.nixos.dconf-dark.programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings."org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "adw-gtk3-dark";
        };
      }
    ];
  };
}
