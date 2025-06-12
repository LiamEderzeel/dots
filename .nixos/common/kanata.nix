{
  config,
  lib,
  pkgs,
  username,
  ...
}:

{
  # Enable the uinput module
  boot.kernelModules = [ "uinput" ];

  # Enable uinput
  hardware.uinput.enable = true;

  # Set up udev rules for uinput
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  # Ensure the uinput group exists
  users.groups.uinput = { };

  # Add the Kanata service user to necessary groups
  systemd.services.kanata-internalKeyboard.serviceConfig = {
    SupplementaryGroups = [
      "input"
      "uinput"
    ];
  };

  users.users.${username} = {
    extraGroups = [ "input" "uinput" ];
  };

  environment = {
    systemPackages = [
      pkgs.kanata
    ];
  };

  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        devices = [
          # Replace the paths below with the appropriate device paths for your setup.
          # Use `ls /dev/input/by-path/` to find your keyboard devices.
          "/dev/input/by-path/pci-0000:09:00.3-usb-0:2:1.0-event-kbd" # ergodox
          "/dev/input/by-path/pci-0000:09:00.3-usb-0:3:1.0-event-kbd" # keycron
        ];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
        (defsrc
          caps a s d f j k l ;
        )
        (defvar
          tap-time 250
          hold-time 250
        )
        
        (defalias
          escctrl (tap-hold $tap-time $hold-time esc lctl)
          a (multi f24 (tap-hold $tap-time $hold-time a lmet))
          s (multi f24 (tap-hold $tap-time $hold-time s lalt))
          d (multi f24 (tap-hold $tap-time $hold-time d lsft))
          f (multi f24 (tap-hold $tap-time $hold-time f lctl))
          j (multi f24 (tap-hold $tap-time $hold-time j rctl))
          k (multi f24 (tap-hold $tap-time $hold-time k rsft))
          l (multi f24 (tap-hold $tap-time $hold-time l ralt))
          ; (multi f24 (tap-hold $tap-time $hold-time ; rmet))
        )
        
        (deflayer base
          @escctrl @a @s @d @f @j @k @l @;
        )
        '';
      };
    };
  };
}
