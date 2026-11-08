{ pkgs, lib, username, ... }:
{
  boot.loader.systemd-boot.enable = true;

  networking.networkmanager.enable = true;

  users.users.${username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      lazygit
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    tmux
    zsh
    git
    proxmox-ve
    btop
  ];


  # TODO: does not work right now
  # services.proxmox-ve = {
  #   enable = true;
  #   vms = {
  #     vm1 = {
  #       vmid = 100;
  #       memory = 4096;
  #       cores = 4;
  #       sockets = 2;
  #       kvm = false;
  #       net = [
  #         {
  #           model = "virtio";
  #           bridge = "vmbr0";
  #         }
  #       ];
  #       scsi = [ { file = "local:128"; } ];
  #     };
  #     # myvm2 = {
  #     #   vmid = 101;
  #     #   memory = 8192;
  #     #   cores = 2;
  #     #   sockets = 2;
  #     #   scsi = [ { file = "local:32"; } ];
  #     # };
  #   };
  # };

  systemd.network.networks."10-lan" = {
      matchConfig.Name = [ "ens18" ];
      networkConfig = {
      Bridge = "vmbr0";
      };
  };

  systemd.network.netdevs."vmbr0" = {
    netdevConfig = {
      Name = "vmbr0";
      Kind = "bridge";
    };
  };

  systemd.network.networks."10-lan-bridge" = {
    matchConfig.Name = "vmbr0";
    networkConfig = {
    IPv6AcceptRA = true;
    DHCP = "ipv4";
    };
    linkConfig.RequiredForOnline = "routable";
  };

  networking.bridges.vmbr0.interfaces = [ "ens18" ];
  networking.interfaces.vmbr0.useDHCP = lib.mkDefault true;

  system.stateVersion = "24.05"; # Did you read the comment?
}
