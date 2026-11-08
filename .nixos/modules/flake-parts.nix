{
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  options.meta = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    description = "Values shared by all hosts";
  };

  config = {
    systems = [ "x86_64-linux" ];

    meta = {
      username = "liamederzeel";
      system = "x86_64-linux";
    };

    perSystem =
      { pkgs, ... }:
      {
        formatter = pkgs.nixfmt;
      };
  };
}
