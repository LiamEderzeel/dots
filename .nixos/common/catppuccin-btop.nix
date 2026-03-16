{ config, pkgs, lib, username, ... }:

let
  catppuccinBtop = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "btop";
    rev = "main";
    sha256 = "sha256-mEGZwScVPWGu+Vbtddc/sJ+mNdD2kKienGZVUcTSl+c=";
  };
in
{
  environment.systemPackages = [ pkgs.btop ];

  system.activationScripts.catppuccinBtop = {
    text = ''
      mkdir -p /home/${username}/.config/btop/themes
      cp ${catppuccinBtop}/themes/catppuccin_mocha.theme \
         /home/${username}/.config/btop/themes/
      chown ${username}:users /home/${username}/.config/btop/themes/catppuccin_mocha.theme
    '';
    deps = [];
  };
}
