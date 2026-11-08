{ config, inputs, ... }:
let
  inherit (config.meta) username system;
in
{
  flake.modules.nixos.base =
    { lib, ... }:
    {
      _module.args = {
        inherit inputs username system;
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nixpkgs.config.allowUnfree = true;

      time.timeZone = "Europe/Amsterdam";
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = lib.genAttrs [
        "LC_ADDRESS"
        "LC_IDENTIFICATION"
        "LC_MEASUREMENT"
        "LC_MONETARY"
        "LC_NAME"
        "LC_NUMERIC"
        "LC_PAPER"
        "LC_TELEPHONE"
        "LC_TIME"
      ] (_: "nl_NL.UTF-8");

      programs.zsh.enable = true;
      services.openssh.enable = true;
    };
}
