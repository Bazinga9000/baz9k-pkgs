{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "times-new-argam";
  version = "2024-11-26";

  # TODO: replace with a more standard fetchurl if a public upload URL ever exists
  src = ./TimesNewArgam2-Regular.ttf;
  dontUnpack = true;

  installPhase = ''
    export FONT_DIR=$out/share/fonts
    mkdir -p $out/share/fonts
    cp $src $FONT_DIR/TimesNewArgam2-Regular.ttf
  '';

  meta = {
    description = "A font for displaying the Argam numeral set, created by Shannon Lovelace.";
    homepage = null;
    license = lib.licenses.cc-by-nc-40;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
