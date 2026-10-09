
{pkgs-unstable, ...}:
{
  environment.systemPackages = with pkgs-unstable; [trayscale];

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client"; # or "server" if you're also relaying/exit-noding
    # openFirewall = true; # usually not needed since tailscale uses its own interface,
                            # but relevant if you're doing subnet routing / exit node
  };
}
