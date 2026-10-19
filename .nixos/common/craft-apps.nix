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
    version = "0.10.0";
    hash = "sha256-zRozyXnopdqU3tgddkjnecuAabd+Ssp0PI0XfKUnDXc=";
  })
  (mkCraftApp {
    pname = "vectorcraft";
    version = "0.13.1";
    hash = "sha256-lUV7ubSLxjRBJMK/MqEGAGVIqllLG40djKR9UqMOV34=";
  })
  (mkCraftApp {
    pname = "gridcraft";
    version = "0.8.0";
    hash = "sha256-lCCWoppTSqJQPp56oYFulS9yUOc9VfjzKv0HdUdhf3c=";
  })
  (mkCraftApp {
    pname = "wordcraft";
    version = "0.8.0";
    hash = "sha256-ffezpQFyug7ehaLEuDw2CvkrHDdnyLMMOWPr8F02q5w=";
  })
]
