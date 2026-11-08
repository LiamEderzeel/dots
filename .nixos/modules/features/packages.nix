{ ... }:
{
  flake.modules.nixos.packages =
    {
      pkgs,
      pkgs-unstable,
      system,
      inputs,
      ...
    }:
    let
      freecadWayland = pkgs.symlinkJoin {
        name = "freecad-wayland-fix";
        paths = [ pkgs.freecad-wayland ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/FreeCAD \
          --set QT_AUTO_SCREEN_SCALE_FACTOR "0" \
          --set QT_SCALE_FACTOR "1" \
          --prefix MESA_LOADER_DRIVER_OVERRIDE : zink \
          --prefix __EGL_VENDOR_LIBRARY_FILENAMES : ${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json
        '';
      };

      # the webview crashes with a Wayland protocol error on NVIDIA without this
      orcaSlicer = pkgs.symlinkJoin {
        name = "orca-slicer-dmabuf-fix";
        paths = [ pkgs-unstable.orca-slicer ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/orca-slicer --set WEBKIT_DISABLE_DMABUF_RENDERER 1
        '';
      };

      packages = [
        inputs.tmux-booster
        inputs.zen-browser.packages."${system}".specific
      ];
      unstable = with pkgs-unstable; [
        feedr
        obsidian
        television
        fd
        networkmanagerapplet
        proton-vpn
        resources
        gjs
        awww
        slurp
        grim
        teensy-loader-cli
        teensy-udev-rules
        darktable
        xdg-desktop-portal-hyprland
        mgba # gameboy advanced
        lsb-release # For mongodb-memory-server
        freetube
        papirus-icon-theme
        bibata-cursors
        glib
        gsettings-desktop-schemas
        ripgrep
        easyeffects
        quickshell
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
        libation
        nautilus
        bitwarden-cli
      ];
      stable = with pkgs; [
        where-is-my-sddm-theme
        tmux
        hyprpaper
        waybar
        waypaper
        firefox
        rofi
        keyd
        eog
        xwayland
        xdg-desktop-portal-gtk
        libsForQt5.qt5.qtquickcontrols2
        libsForQt5.qt5.qtgraphicaleffects
        fzf
        hyprlock
        hypridle
        pavucontrol
        wev # xevents to see keyboard and mouse events
        brightnessctl
        eza
        vlc
        mpv
        kdePackages.gwenview
        librsvg
        playerctl
        inkscape
        gnome-disk-utility
        jq
        gimp
        baobab
        showmethekey
        kicad
        blender
        libreoffice
        # freecad
        freecadWayland
        orcaSlicer
        gphoto2
        kdePackages.kdenlive
        chromium
        spotify
      ];
    in
    {
      environment.systemPackages = builtins.concatLists [
        unstable
        stable
        packages
        (pkgs.callPackage ../_pkgs/mongodb.nix { inherit pkgs-unstable; })
        (import ../_pkgs/craft-apps.nix { inherit pkgs; })
      ];
    };
}
