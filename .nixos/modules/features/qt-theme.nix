{ ... }:
{
  flake.modules.nixos.qt-theme.qt = {
    enable = true;
    platformTheme = "qt5ct";
  };
}
