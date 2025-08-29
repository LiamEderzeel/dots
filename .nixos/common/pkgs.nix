{ pkgs,
  pkgs-unstable,
  system,
  inputs,
 ...}:
let
  themes = pkgs.callPackage  ./configs/sddm-themes.nix {};
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
    # mongodb-compass
    (pkgs.runCommand "mongodb-compass-wrapped" {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      desktopItem = pkgs.makeDesktopItem {
        name = "MongoDBCompass";
        desktopName = "MongoDB Compass";
        exec = "mongodb-compass-gnome";
        icon = "mongodb-compass";
        genericName = "MongoDB GUI";
        categories = [ "Development" "Database" "Utility" ];
      };
      passAsFile = [ "desktopItem" ];
    } ''
      mkdir -p $out/bin
      makeWrapper ${pkgs-unstable.mongodb-compass}/bin/mongodb-compass $out/bin/mongodb-compass-gnome \
        --set XDG_CURRENT_DESKTOP "GNOME"
    
      mkdir -p $out/share/applications
      cp "$(cat $desktopItemPath)"/share/applications/MongoDBCompass.desktop $out/share/applications/
    
      mkdir -p $out/share/icons
      ln -s ${pkgs-unstable.mongodb-compass}/share/icons/* $out/share/icons/
    '')
    mongosh
    mongodb-tools
    darktable
    obsidian
    librewolf
    fastfetch
    ranger
    ueberzugpp

    nodePackages."@antfu/ni"
    nodejs_20
    pnpm_10
    # corepack_latest
    deno
    yazi
    rustc 
    cargo 
    television
    fd
    minikube
    networkmanagerapplet
    protonvpn-gui
    postman
    resources
    discord
    ags
    gjs
    swww
    openssl
    sqlitebrowser
    zip
    slurp
    grim
    teensy-loader-cli
    teensy-udev-rules
  ];
  stable = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    wlr-randr
    tmux
    git
    openssh
    hyprland 
    hyprpaper
    waybar
    waypaper
    firefox-wayland 
    alacritty 
    rofi-wayland
    keyd
    nautilus
    eog
    xwayland
    xdg-desktop-portal-hyprland
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
    gwenview
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
    themes.where-is-my-sddm-theme
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
    hyprpanel
  ];
in
{
  environment.systemPackages = unstable ++ stable ++ packages;
}
