{ ... }:
{
  flake.modules.nixos.dev-tools =
    { pkgs, pkgs-unstable, ... }:
    {
      environment.systemPackages =
        (with pkgs-unstable; [
          nodejs_22
          pnpm_10
          corepack
          deno
          rustc
          rust-analyzer
          clippy
          rustfmt
          cargo
          openssl
          postman
          sqlitebrowser
          pgadmin4-desktopmode
          opentofu
          direnv
          powershell
        ])
        ++ (with pkgs; [
          git
          lazygit
          nix-prefetch-git
          nixd
          gcc
          python3
          lua-language-server
          kubectl
          kubernetes-helm
          kubeseal
          skaffold
          doctl
        ]);
    };
}
