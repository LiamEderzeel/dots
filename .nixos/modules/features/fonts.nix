{ ... }:
{
  flake.modules.nixos.fonts =
    { pkgs, ... }:
    {
      fonts = {
        fontDir.enable = true;
        packages = with pkgs; [
          nerd-fonts.roboto-mono
          font-awesome
          google-fonts
        ];
      };
    };
}
