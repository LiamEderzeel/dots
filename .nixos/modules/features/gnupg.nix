{ ... }:
{
  flake.modules.nixos.gnupg.programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
