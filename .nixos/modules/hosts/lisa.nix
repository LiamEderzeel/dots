{ config, inputs, ... }:
{
  flake.nixosConfigurations.lisa = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [
      base
      packages
      wayland
      fonts
      { networking.hostName = "lisa"; }
      ./_lisa/hardware.nix
      ./_lisa/configuration.nix
    ];
  };
}
