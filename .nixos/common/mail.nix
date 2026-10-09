{ pkgs-unstable, ... }:

{
  environment.systemPackages = with pkgs-unstable; [ protonmail-bridge ];

  systemd.user.services.protonmail-bridge = {
    description = "Protonmail Bridge";
    # Wait for the desktop session and network to be fully ready
    after = [ "network.target" "graphical-session.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs-unstable.protonmail-bridge}/bin/protonmail-bridge --noninteractive --log-level info";
      # Pass the user's active D-Bus session address so it can reach the keyring
      Environment = [
        "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/%U/bus"
      ];
    };
  };
}
