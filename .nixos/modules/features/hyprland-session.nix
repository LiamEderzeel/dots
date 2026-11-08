{ ... }:
{
  flake.modules.nixos.hyprland-session =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.displayManager.sessionPackages = [
        (pkgs.writeTextFile {
          name = "hyprland-uwsm-fixed";
          text = ''
            [Desktop Entry]
            Name=Hyprland (UWSM)
            Comment=Hyprland compositor managed by UWSM
            Exec=${lib.getExe config.programs.uwsm.package} start -F -- /run/current-system/sw/bin/start-hyprland
            Type=Application
            DesktopNames=Hyprland
            Keywords=tiling;wayland;compositor;
          '';
          destination = "/share/wayland-sessions/hyprland-uwsm-fixed.desktop";
          derivationArgs = {
            passthru.providedSessions = [ "hyprland-uwsm-fixed" ];
          };
        })
      ];
    };
}
