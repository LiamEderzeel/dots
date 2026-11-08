{ config, inputs, ... }:
{
  flake.nixosConfigurations.lab1 = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [
      base
      proxmox
      { networking.hostName = "lab1"; }
      ./_lab1/hardware.nix
      ./_lab1/configuration.nix
    ];
  };
}
