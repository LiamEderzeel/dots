{ inputs, ... }:
{
  flake.modules.nixos.nix-ld =
    { pkgs, ... }:
    {
      imports = [ inputs.nix-ld.nixosModules.nix-ld ];

      # Fix hardcoded /bin and /usr/bin paths in unpackaged programs
      services.envfs.enable = true;

      # Dynamic libraries for unpackaged programs
      programs.nix-ld.enable = true;
      programs.nix-ld.dev.enable = false;
      programs.nix-ld.libraries = with pkgs; [
        glibc
        libcxx
      ];
    };
}
