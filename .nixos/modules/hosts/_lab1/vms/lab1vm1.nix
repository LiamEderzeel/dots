# TODO: does not work right now
{ config, ... }:
{
  # imports = [ ./disko.nix ];

  networking.hostName = "vm1";

  virtualisation.proxmox = {
    node = "myproxmoxnode";
    # iso = <derivation for your iso>;
    vmid = 101;
    memory = 4096;
    cores = 1;
    sockets = 2;
    net = [
      {
        model = "virtio";
        bridge = "vmbr0";
      }
    ];
    scsi = [ { file = "local:128"; } ]; # This will create a 16GB volume in 'local'
  };

  # The rest of your configuration...
}
  
