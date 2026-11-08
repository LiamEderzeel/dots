{ inputs, ... }:
{
  flake.modules.nixos.nix-ld =
    { pkgs, ... }:
    {
      imports = [ inputs.nix-ld.nixosModules.nix-ld ];

      # Dynamic libraries for unpackaged programs
      programs.nix-ld.enable = true;
      programs.nix-ld.dev.enable = false;
      programs.nix-ld.libraries = with pkgs; [
        glibc
        libcxx
      ];
    };
}
