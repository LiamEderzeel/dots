{ pkgs, ... }:
{
  # Dynamic libraries for unpackaged programs
  programs.nix-ld.enable = true;
  programs.nix-ld.dev.enable = false;
  programs.nix-ld.libraries = with pkgs; [
    glibc
    libcxx
  ];
}
