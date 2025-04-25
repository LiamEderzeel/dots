# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# export PATH=/run/wrappers/bin /home/r/.nix-profile/bin /etc/profiles/per-user/r/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-unstable, hostname, username, ... }:
{
  imports = [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common/pkgs.nix
      ../common/kanata.nix
      ../common/wayland.nix
      ../common/configs/fonts.nix
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

  # # sound.enable = true;
  # hardware.pulseaudio = {
  #   # enable = true;
  #   support32Bit = true;
  # };

 # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    extraLv2Packages = [ pkgs.rnnoise-plugin ];
    configPackages = [
      (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/20-rnnoise.conf" ''
        context.modules = [
        {   name = libpipewire-module-filter-chain
            args = {
                node.description = "Noise Canceling source"
                media.name = "Noise Canceling source"
                filter.graph = {
                    nodes = [
                        {
                            type = lv2
                            name = rnnoise
                            plugin = "https://github.com/werman/noise-suppression-for-voice#stereo"
                            label = noise_suppressor_stereo
                            control = {
                            }
                        }
                    ]
                }
                capture.props = {
                    node.name =  "capture.rnnoise_source"
                    node.passive = true
                }
                playback.props = {
                    node.name =  "rnnoise_source"
                    media.class = Audio/Source
                }
            }
        }
        ]
      '')
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "${hostname}"; 
  networking.extraHosts = ''
    127.0.0.1 whas.test
    127.0.0.1 portal.whas.test

    127.0.0.1 hot.test
    127.0.0.1 academy.hot.test
    127.0.0.1 admin.hot.test
    127.0.0.1 ams.hot.test
    127.0.0.1 ams2.hot.test
  '';
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.wireless = {
  #   enable = true;  # Enables wireless support via wpa_supplicant.
  #   networks."Netbarry-Home-N".psk = "eTnFMNCbXnh3Egbp";
  # };
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

   hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };


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
        output="DP-2";
        primary=true;
      }
      {
        output = "DP-1";
        monitorConfig = ''Option "Enable" "false"'';
      }
    ];
    exportConfiguration=true;
  };

  services.displayManager.sddm = {
    enable = true;
    package = pkgs.libsForQt5.sddm;
    theme = "where-is-my-sddm-theme";
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
    extraGroups = [ "networkmanager" "wheel" "audio" "docker" ];
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
      GTK_THEME = "Adwaita:dark";
      QT_THEME = "Adwaita:dark"; # not sure if real
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };
    systemPackages = [
      # pkgs-unstable.coolercontrol.coolercontrold
      # pkgs-unstable.coolercontrol.coolercontrol-gui
      # pkgs-unstable.coolercontrol.coolercontrol-liqctld
      pkgs.vscode
      # pkgs-unstable.dbgate
    ];
  };

  # programs.hyprpanel = {
  #   enable = true;
  # };

  programs.coolercontrol.enable = true;

  programs.steam.enable = true;

  programs.zsh = {
    enable = true;
  };

  # programs.waybar = {
  #   enable = true;
  # };

  # Dynamic libraries for unpackaged programs
  programs.nix-ld.dev.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    glibc
    libcxx
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  system.stateVersion = "24.11"; # Did you read the comment?

  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];
}
