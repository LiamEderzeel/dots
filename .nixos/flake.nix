# /etc/nixos/flake.nix
{
  description = "multi-machine system flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";
    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";
    tmux-booster = {
      url = "github:LiamEderzeel/tmux-booster";
    };
    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
    };
    hyprpanel.url = "github:jas-singhfsu/hyprpanel";
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    proxmox-nixos,
    nix-ld,
  # nixos-boot,
    ...
  } @ inputs: let
  # pkgs-unstable = import nixpkgs-unstable {
  #   inherit system;
  #
  #   config = {
  #     allowUnfree = true;
  #     # allowUnfreePredicate = _: true;
  #   };
  # };

  # pkgs = import nixpkgs {
  #   inherit system;
  #   overlays = [
  #     # inputs.nur.overlay
  #   ];
  #
  #
  #   config = {
  #     allowUnfree = true;
  #     # allowUnfreePredicate = _: true;
  #   };
  # };


  stateVersion = "24.11"; 
    username = "liamederzeel"; 
    desktop = "machine"; 
    laptop = "lisa"; 
    lab1 = "lab1"; 
    system = "x86_64-linux"; # Rarely, change system architecture
    email = "liamederzeel@gmail.com"; # your email for Git and such 
    # discord = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTI1NDEyMDE3ODA3NDEyODQ5Ni9jdklWWVlfZURGMXRLcmR1aHJRW"; # Change/ remove
    in {
      #  NixOS configuration entrypoint
      #  Available through 'nixos-rebuild --flake .# your-hostname'
      nixosConfigurations = {
        ${desktop} = nixpkgs.lib.nixosSystem {
          specialArgs = let
            hostname = "${desktop}";  in {
              inherit
                inputs
                self
                username
                system
                stateVersion
                email
                # discord
                hostname;

            pkgs-unstable = import nixpkgs-unstable {
              inherit system;

              config = {
                allowUnfree = true;
                # allowUnfreePredicate = _: true;
              };
            };
          };

          modules = [./${desktop}/configuration.nix nix-ld.nixosModules.nix-ld {nixpkgs.overlays = [inputs.hyprpanel.overlay];}];

          # modules = [./nixos/${desktop}/configuration.nix nixos-boot.nixosModules.default];
        };
        ${laptop} = nixpkgs.lib.nixosSystem { 
          specialArgs = let hostname = "${laptop}";  in {
            inherit
              inputs
              self
              username
              system
              stateVersion
              email
              # discord
              hostname;
          };
          modules = [./${laptop}/configuration.nix];
          # modules = [./nixos/${laptop}/configuration.nix nixos-boot.nixosModules.default];
        };
        ${lab1} = nixpkgs.lib.nixosSystem { 
          specialArgs = let hostname = "${lab1}";  in {
            inherit
              inputs
              self
              username
              system
              stateVersion
              hostname;
          };
          # modules = [./${lab1}/configuration.nix ];
          modules = [
            ./${lab1}/configuration.nix 

            ({ pkgs, lib, ... }: {
              services.proxmox-ve.enable = true;
              nixpkgs.overlays = [
                proxmox-nixos.overlays.${system}
              ];

            })

            proxmox-nixos.nixosModules.proxmox-ve 
            ];
        };
      };
  };
}

    # overlays = import ./overlays {inherit inputs;};
    # # NOTE: 'nixos' is the default hostname set by the installer
    # nixosConfigurations.machine = nixpkgs.lib.nixosSystem {
    #   # NOTE: Change this to aarch64-linux if you are on ARM
    #   system = "x86_64-linux";
    #   modules = [ ./configuration.nix ];
    # };
