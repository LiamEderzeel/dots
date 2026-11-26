{ ... }:
{
  flake.modules.nixos.nvidia =
    { config, pkgs, ... }:
    {
      boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

      environment.variables = {
        # Use NVIDIA's GBM backend
        GBM_BACKEND = "nvidia-drm";
        # Tell GL to use the NVIDIA vendor library
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        # Enable video acceleration via NVIDIA
        LIBVA_DRIVER_NAME = "nvidia";
        NVD_BACKEND = "direct";
      };

      hardware.graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ];

      hardware.nvidia = {

        # Modesetting is required.
        modesetting.enable = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
        # of just the bare essentials.
        powerManagement.enable = true;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = false;

        # Open kernel module, recommended by NVIDIA for Turing and newer.
        open = true;

        # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
        nvidiaSettings = true;

        # Optionally, you may need to select the appropriate driver version for your specific GPU.
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };
    };
}
