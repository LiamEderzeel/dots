{username, pkgs-unstable, ...}:
{
  environment.systemPackages = with pkgs-unstable; [syncthing];

  services.syncthing = {
    enable = true;
    user = "${username}";
    group = "users";
    configDir = "/home/${username}/.config/syncthing";
  };
}
