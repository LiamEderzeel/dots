{ pkgs,
  pkgs-unstable,
  system,
  inputs,
 ...}:
let
  # themes = pkgs.callPackage  ./configs/sddm-themes.nix {};

  # orcaSlicerWrapped = pkgs.symlinkJoin {
  #   name = "orca-slicer-wrapped";
  #   paths = [ pkgs.orca-slicer ];
  #   buildInputs = [ pkgs.makeWrapper ];
  #   postBuild = ''
  #     wrapProgram $out/bin/orca-slicer \
  #     --set GBM_BACKEND dri
  #   '';
  # };

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
    ferdium
    obsidian
    nodejs_22
    pnpm_10
    # corepack_latest
    corepack
    deno
    rustc 
    rust-analyzer
    clippy
    rustfmt
    cargo 
    television
    fd
    networkmanagerapplet
    proton-vpn
    postman
    resources
    discord
    gjs
    awww
    openssl
    sqlitebrowser
    slurp
    grim
    teensy-loader-cli
    teensy-udev-rules
    darktable
    signal-desktop
    xdg-desktop-portal-hyprland
    # kdePackages.qt5compat
    mgba # gameboy advanced
    claude-code
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
    slack
    telegram-desktop
    thunderbird
    gajim
  ];
  stable = with pkgs; [
    where-is-my-sddm-theme
    # themes.where-is-my-sddm-theme
    tmux
    git
    lazygit
    lazydocker
    hyprpaper
    waybar
    waypaper
    firefox 
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
    hyprlock
    hypridle
    pavucontrol
    wev # xevents to see keyboard and mouse events
    brightnessctl
    eza
    nemo-with-extensions   
    vlc
    mpv
    kdePackages.gwenview
    gcc
    librsvg
    node2nix
    nixd
    docker_29
    kubectl
    kubeseal
    doctl
    python3
    playerctl
    inkscape
    lua-language-server
    gnome-disk-utility
    docker-compose
    jq
    gimp
    baobab
    kubernetes-helm
    skaffold
    showmethekey
    kicad
    blender
    libreoffice
    # freecad
    freecadWayland
    # orcaSlicerWrapped
    orca-slicer
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
    (pkgs.callPackage ./mongodb.nix { inherit pkgs-unstable; })
  ];
}
