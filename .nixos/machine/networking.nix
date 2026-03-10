{ hostname, ... }:
{
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

  networking.wg-quick.interfaces = {
    wg0 = {
      configFile = "/etc/wireguard/wg0.conf";
    };
    wg1 = {
      configFile = "/etc/wireguard/wg1.conf";
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
