{ pkgs, pkgs-unstable }:

[
  (pkgs.runCommand "mongodb-compass-wrapped" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
    desktopItem = pkgs.makeDesktopItem {
      name = "MongoDBCompass";
      desktopName = "MongoDB Compass";
      exec = "mongodb-compass-gnome";
      icon = "mongodb-compass";
      genericName = "MongoDB GUI";
      categories = [ "Development" "Database" "Utility" ];
    };
    passAsFile = [ "desktopItem" ];
  } ''
    mkdir -p $out/bin
    makeWrapper ${pkgs-unstable.mongodb-compass}/bin/mongodb-compass $out/bin/mongodb-compass-gnome \
      --set XDG_CURRENT_DESKTOP "GNOME"
   
    mkdir -p $out/share/applications
    cp "$(cat $desktopItemPath)"/share/applications/MongoDBCompass.desktop $out/share/applications/
   
    mkdir -p $out/share/icons
    ln -s ${pkgs-unstable.mongodb-compass}/share/icons/* $out/share/icons/
  '')
  pkgs-unstable.mongosh
  pkgs-unstable.mongodb-tools
]
