{ config, inputs, ... }:
{
  flake.nixosConfigurations.toaster = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [
      base
      packages
      kanata
      printer
      wayland
      fonts
      nvidia
      syncthing
      tailscale
      terminal
      mail
      communication
      dev-tools
      docker
      sops
      ai
      audio
      nix-ld
      noctalia
      catppuccin-btop
      ./_toaster/hardware.nix
      ./_toaster/networking.nix
      ./_toaster/configuration.nix
    ];
  };
}
