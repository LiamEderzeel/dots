{ pkgs }:

# ArtCraft "Crafting Apps" (https://getartcraft.com/apps), packaged from the
# upstream AppImages. To update: bump version and hash from the release's
# SHA256SUMS.txt (`nix hash convert --hash-algo sha256 --to sri <hex>`).
let
  mkCraftApp = { pname, version, hash }:
    let
      src = pkgs.fetchurl {
        url = "https://github.com/storytold/${pname}/releases/download/v${version}/${pname}-${version}-linux-x86_64.AppImage";
        inherit hash;
      };
      contents = pkgs.appimageTools.extractType2 { inherit pname version src; };
    in
    pkgs.appimageTools.wrapType2 {
      inherit pname version src;
      extraInstallCommands = ''
        install -Dm444 ${contents}/ai.storyteller.${pname}.desktop -t $out/share/applications
        cp -r ${contents}/usr/share/icons $out/share/
      '';
    };
in
[
  (mkCraftApp {
    pname = "photocraft";
    version = "0.5.0";
    hash = "sha256-9U2GOAcFO738/6DWJO9+SdP9QTEMe7Ht5IU29pkp0i8=";
  })
  (mkCraftApp {
    pname = "vectorcraft";
    version = "0.7.0";
    hash = "sha256-9pKPmt9COtChRev+OxQqldPSb1ULBSScIBIUVwH5i2A=";
  })
]
