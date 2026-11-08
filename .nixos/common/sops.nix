{ config, pkgs, inputs, ... }:
{
  sops = {
    # sops-nix needs go >= 1.26, but the default go on nixpkgs 25.11 is 1.25
    package =
      (import inputs.sops-nix {
        pkgs = pkgs.extend (_: prev: { buildGoModule = prev.buildGo126Module; });
      }).sops-install-secrets;
    defaultSopsFile = ../secrets/${config.networking.hostName}.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      test_secret = { };
    };
  };
}
