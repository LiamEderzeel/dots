{ pkgs,
  pkgs-unstable,
  system,
  inputs,
 ...}:
let
  # themes = pkgs.callPackage  ./configs/sddm-themes.nix {};

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
  packages = [ 
    inputs.tmux-booster
    inputs.zen-browser.packages."${system}".specific
  ];
  unstable = with pkgs-unstable; [
    neovim
    ferdium
    spotify
    lazygit
    lazydocker
    obsidian
    librewolf
    fastfetch
    ranger
    ueberzugpp
    nodePackages."@antfu/ni"
    nodejs_22
    pnpm_10
    # corepack_latest
    deno
    yazi
    rustc 
    rust-analyzer
    clippy
    rustfmt
    cargo 
    television
    fd
    minikube
    networkmanagerapplet
    protonvpn-gui
    postman
    resources
    discord
    gjs
    swww
    openssl
    sqlitebrowser
    zip
    slurp
    grim
    teensy-loader-cli
    teensy-udev-rules
    hyprpanel
    darktable
    signal-desktop
    xdg-desktop-portal-hyprland
    # kdePackages.qt5compat
    mgba # gameboy advanced
    claude-code
    lsb-release # For mongodb-memory-server 
    freetube
    bluez
    pipewire
    papirus-icon-theme
    bibata-cursors
    glib
  ];
  stable = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    kdePackages.sddm
    where-is-my-sddm-theme
    libsForQt5.qt5.qtgraphicaleffects
    wlr-randr
    tmux
    git
    openssh
    hyprpaper
    waybar
    waypaper
    firefox 
    alacritty 
    rofi
    keyd
    nautilus
    eog
    xwayland
    xdg-desktop-portal-gtk
    nix-prefetch-git
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
    fzf
    ripgrep
    wl-clipboard
    killall
    pulseaudio
    hyprlock
    hypridle
    pavucontrol
    wev # xevents to see keyboard and mouse events
    brightnessctl
    eza
    networkmanagerapplet
    btop
    nemo-with-extensions   
    vlc
    mpv
    kitty
    lf
    kdePackages.gwenview
    gcc
    librsvg
    node2nix
    nixd
    docker
    kubectl
    kubeseal
    doctl
    python3
    playerctl
    inkscape
    # themes.where-is-my-sddm-theme
    lua-language-server
    xz
    exfat
    # gnome.gnome-disk-utility
    gnome-disk-utility
    docker-compose
    unzip
    jq
    weston
    lm_sensors
    gimp
    baobab
    zoxide
    kubernetes-helm
    skaffold
    wireguard-tools
    dig
    usbutils
    showmethekey
    kicad
    blender
    dysk
    # freecad
    freecadWayland
    libreoffice
    
    (pkgs.runCommand "orca-slicer-wrapped" {
      desktopItem = pkgs.makeDesktopItem {
        name = "OrcaSlicer";
        desktopName = "Orca Slicer";
        exec = "env GBM_BACKEND=dri ${pkgs.orca-slicer}/bin/orca-slicer %U";
        icon = "orca-slicer";
        genericName = "3D Slicer";
        categories = [ "3DGraphics" "Application" ];
      };
      passAsFile = [ "desktopItem" ];
    } ''
      mkdir -p $out/bin
      
      mkdir -p $out/share/applications
      cp "$(cat $desktopItemPath)"/share/applications/OrcaSlicer.desktop $out/share/applications/
      
      mkdir -p $out/share/icons
      ln -s ${pkgs.orca-slicer}/share/icons/* $out/share/icons/
    '')
  ];
in
{
  environment.systemPackages = unstable ++ stable ++ packages ++ 
  (pkgs.callPackage ./mongodb.nix { inherit pkgs-unstable; })
;

}
