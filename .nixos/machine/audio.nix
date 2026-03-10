{ pkgs, ... }:
{
  # # sound.enable = true;
  # hardware.pulseaudio = {
  #   # enable = true;
  #   support32Bit = true;
  # };

  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    wireplumber.enable = true;
    extraConfig.pipewire."92-low-latency" = {};
    wireplumber.extraConfig.bluetoothEnhancements = {
      "monitor.bluez" = {
        "properties" = {
          "bluez5.roles" = [ "hsp_hs" "hfp_hf" "a2dp_sink" "a2dp_source" ];
          "bluez5.codecs" = [ "sbc" "sbc_xq" "aac" "ldac" "aptx" "aptx_hd" ];
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-hw-volume" = true;
        };
      };
    };
  };
  environment.etc."wireplumber/wireplumber.conf.d/51-bluez.conf".text = ''
  monitor.bluez.properties = {
    bluez5.roles = [ a2dp_sink a2dp_source hfp_hf hfp_ag ]
    bluez5.codecs = [ sbc sbc_xq aac ldac aptx aptx_hd ]
    bluez5.enable-sbc-xq = true
    bluez5.enable-hw-volume = true
  }
  '';
}
