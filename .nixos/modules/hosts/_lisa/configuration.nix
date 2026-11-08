# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# export PATH=/run/wrappers/bin /home/r/.nix-profile/bin /etc/profiles/per-user/r/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ 
  pkgs,
  username,
  ...
 }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
    # unmanaged = ["wlp3s0"];
    wifi = {
      scanRandMacAddress = false;
      macAddress = "permanent";
    };
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "mac";
    };
  };

  services.displayManager.sddm = {
    enable = true;
    package = pkgs.libsForQt5.sddm;
    theme = "where-is-my-sddm-theme.nix";
    wayland.enable = true;
  };

  services.keyd.enable = true;
  
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "networkmanager" "wheel" "audio" "docker" ];
    packages = with pkgs; [];
  };
  users.defaultUserShell = pkgs.zsh;

  environment = {
    sessionVariables = {
      FLAKE = "/home/${username}/.nixos";
    };
    variables = {
      GDK_SCALE = 2;
    };
  };

  programs.dconf = {
    enable = true;
    profiles.user.databases = [{
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    }];
  };

  programs.waybar = {
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
