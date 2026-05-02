{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "nahuatl-one-font";
  version = "2021-03-21";

  dontUnpack = true;

  src = fetchurl {
    url = "https://github.com/piratical/NahuatlTools/raw/35797c5562b7c266e632364470bf4d93f8418b4a/NahuatlOneFont/NahuatlOne_2021_03_21.otf";
    hash = "sha256-S5xUYbzEM7NfCGzWMQ0xC6/xfbSElaISo4ZJ8sZSGVc=";
  };

  installPhase = ''
    export FONT_DIR=$out/share/fonts
    mkdir -p $out/share/fonts
    cp $src $FONT_DIR/nahuatl_one.otf
  '';

  meta = {
    description = "Font for a Nahuatl abugida.";
    homepage = "https://unifont.org/nahuatl/";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
