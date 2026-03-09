{ stdenv, fetchFromGitHub }:
{
  where-is-my-sddm-theme = stdenv.mkDerivation rec {
    name = "where-is-my-sddm-theme";
    pname = "where-is-my-sddm-theme";
    src = fetchFromGitHub {
      owner = "stepanzubkov";
      repo = "where-is-my-sddm-theme";
      rev = "963715453e069c1698383f2d5a89e9a58110296a";
      sha256 = "192a3dgkfkp0a696xdbxpkbwwynpd4sypvvwhhrs6nhaiqbikb7n";
    };
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src/where_is_my_sddm_theme $out/share/sddm/themes/where-is-my-sddm-theme
    '';
  };
  abstractguts-themes = stdenv.mkDerivation rec {
    pname = "abstractdark-themes";
    version = "";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/abstractguts-themes
    '';
    src = fetchFromGitHub {
      owner = "HirschBerge";
      repo = "abstractdark-sddm-theme";
      rev = "60284c29afebb7288ad0aea75bb93b064d9d0264";
      sha256 = "1c5azi6lvhmpbkdzc2ln33g32fh1ms0rbw2r3f0b9j81hwhl6fms";
    };
  };
}
