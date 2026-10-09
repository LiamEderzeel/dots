{pkgs-unstable, ...}:
{
  environment.systemPackages = with pkgs-unstable; [
    kitty
    neovim
    claude-code
    tmux
    zoxide

    # file managers
    ranger
    yazi
    lf
    ueberzugpp

    # search/nav
    fzf
    ripgrep
    fd
    eza
    jq

    # network
    openssh
    dig
    wireguard-tools
    wl-clipboard
    wlr-randr

    # archive/file utils
    zip
    unzip
    xz
    exfat
    usbutils
    dysk
    killall

    # system monitoring
    btop
    fastfetch
    lm_sensors

    esptool
    esphome
  ];
}
