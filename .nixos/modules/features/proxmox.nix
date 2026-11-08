{ config, inputs, ... }:
{
  flake.modules.nixos.proxmox = {
    imports = [ inputs.proxmox-nixos.nixosModules.proxmox-ve ];

    nixpkgs.overlays = [ inputs.proxmox-nixos.overlays.${config.meta.system} ];
    services.proxmox-ve.enable = true;
  };
}
