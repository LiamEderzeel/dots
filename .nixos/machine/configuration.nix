# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# export PATH=/run/wrappers/bin /home/r/.nix-profile/bin /etc/profiles/per-user/r/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, username, lib, ... }:
{
  imports = [
      ./hardware-configuration.nix
      ../common/pkgs.nix
      ../common/kanata.nix
      ../common/printer.nix
      ../common/wayland.nix
      ../common/configs/fonts.nix
      ../common/nvidia.nix
      ../common/syncthing.nix
      ./networking.nix
      ./audio.nix
      ./nix-ld.nix
      ../common/catppuccin-btop.nix 
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "ntfs" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    it87
  ];
  boot.kernelModules = [ "coretemp" "it87" ];
  boot.kernelParams = [ "acpi_enforce_resources=lax" ];
  boot.extraModprobeConfig = ''
    options it87 force_id=0x8628
  '';


  systemd.services.display-manager.enable = true;
 # rtkit is optional but recommended
  security.rtkit.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };
  services.gvfs.enable = true;
  services.udisks2.enable = true;


  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  hardware.xone.enable = true;

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "mac";
    };
    videoDrivers = ["nvidia"];
    xrandrHeads=[
      {
        # monitorConfig = ''
        #   Option "Above" "multihead1"
        # '';
        output = "DP-1";
        # monitorConfig = ''Option "Enable" "false"'';
      }
      {
        output="DP-2";
        primary=true;
        # monitorConfig = ''
        #   Option "Below" "multihead2"
        # '';
      }
    ];
    exportConfiguration=true;
    displayManager.sessionCommands = "xrdb ~/xresources";
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [
      sddm-astronaut
      kdePackages.qt5compat
      kdePackages.qtmultimedia
    ];
    theme = "sddm-astronaut-theme";
    # theme = "${pkgs.sddm-sugar-dark}/share/sddm/themes/sugar-dark";

    settings = {
      # Theme = {
      #   Current = "sddm-astronaut-theme";
      # };
      # Wayland = {
      #   CompositorCommand = "start-hyprland";
      # };
    };
    wayland = {
      enable = true;
      # Proposal
      # setupScript = ''
      #   wlr-randr --output DP-1 --off
      #   wlr-randr --output DP-2 --mode 3840x2160
      # '';
    };
    # setupScript = ''
    #   #!/bin/sh
    #   xrandr --output DP-1 --off
    #   xrandr --output DP-2 --mode 3840x2160
    # '';
  };

  # services.keyd.enable = true;

  services.flatpak.enable = true;
  
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "networkmanager" "wheel" "audio" "docker" "plugdev" "lp" "scanner"];
    packages = with pkgs; [];
  };
  users.defaultUserShell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment = {
    sessionVariables = {
      FLAKE = "/home/${username}/.nixos";
    };
    variables = {
      GDK_SCALE = 2;
      GDK_BACKEND="wayland";
      GTK_THEME = "Adwaita:dark";
      QT_THEME = "Adwaita:dark"; # not sure if real
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      MONGOMS_PLATFORM = "linux";
      MONGOMS_DISTRO = "ubuntu-22.04";
      MONGOMS_VERSION = "7.0.14";
      MONGOMS_DOWNLOAD_URL = "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-7.0.14.tgz";
    };
    systemPackages = [
      # pkgs-unstable.coolercontrol.coolercontrold
      # pkgs-unstable.coolercontrol.coolercontrol-gui
      # pkgs-unstable.coolercontrol.coolercontrol-liqctld
      pkgs.vscode
      # pkgs-unstable.dbgate
    ];
    profileRelativeSessionVariables = {
      XCURSOR_PATH = [
        "$HOME/.icons"
        "$HOME/.local/share/icons"
        "/run/current-system/sw/share/icons"
      ];
    };
  };

  programs.dconf = {
    enable = true;
    profiles.user.databases = [{
      settings = with lib.gvariant; {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "adw-gtk3-dark";
        };
      };
    }];
  };

  programs.coolercontrol.enable = true;

  programs.steam.enable = true;

  programs.zsh = {
    enable = true;
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # fix bin paths
  services.envfs.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];

  # for flashing teensy micro controller
  services.udev.extraRules = ''
    # Rules for Oryx web flashing and live training
    KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
    KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"
    
    # Legacy rules for live training over webusb (Not needed for firmware v21+)
      # Rule for all ZSA keyboards
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
      # Rule for the Moonlander
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
      # Rule for the Ergodox EZ
      SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
      # Rule for the Planck EZ
      SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"
    
    # Wally Flashing rules for the Ergodox EZ
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"
    
    # Keymapp / Wally Flashing rules for the Moonlander and Planck EZ
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
    # Keymapp Flashing rules for the Voyager
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
  '';

  services.blueman.enable = true;

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
}
