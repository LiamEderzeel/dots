# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# export PATH=/run/wrappers/bin /home/r/.nix-profile/bin /etc/profiles/per-user/r/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, username, lib, ... }:
{
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


  services.gvfs.enable = true;
  services.udisks2.enable = true;


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

  # services.keyd.enable = true;

  services.flatpak.enable = true;
  
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "networkmanager" "wheel" "audio" "lp" "scanner" "dialout" "video" "render" ];
    packages = with pkgs; [];
  };
  users.defaultUserShell = pkgs.zsh;

  environment = {
    sessionVariables = {
      FLAKE = "/home/${username}/.nixos";
    };
    variables = {
      GDK_SCALE = 2;
      GDK_BACKEND="wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      MONGOMS_PLATFORM = "linux";
      MONGOMS_DISTRO = "ubuntu-22.04";
      MONGOMS_VERSION = "7.0.14";
      MONGOMS_DOWNLOAD_URL = "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-7.0.14.tgz";
    };
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

  programs.steam.enable = true;

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
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

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
