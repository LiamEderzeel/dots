{ ... }:
{
  # Gigabyte board: it87 needs a forced chip id to expose the fan controller
  flake.modules.nixos.sensors =
    { config, ... }:
    {
      boot.extraModulePackages = [ config.boot.kernelPackages.it87 ];
      boot.kernelModules = [
        "coretemp"
        "it87"
      ];
      boot.kernelParams = [ "acpi_enforce_resources=lax" ];
      boot.extraModprobeConfig = ''
        options it87 force_id=0x8628
      '';
    };
}
