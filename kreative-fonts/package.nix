{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "kreative-kore-fonts";
  version = "2026-02-08";

  dontUnpack = true;

  constructium = fetchzip {
    url = "https://github.com/kreativekorp/open-relay/releases/download/${version}/Constructium.zip";
    hash = "sha256-d8PDrGrAf2gYFeZyu1xToHmS6ndF2QDYSFpokAx9E1w=";
    stripRoot = false;
  };

  fairfax = fetchzip {
    url = "https://github.com/kreativekorp/open-relay/releases/download/${version}/Fairfax.zip";
    hash = "sha256-oZPHY5P+wNdcxzPKp68KO4A0au7awvpEmPK3ivdeBPY=";
    stripRoot = false;
  };

  fairfaxHD = fetchzip {
    url = "https://github.com/kreativekorp/open-relay/releases/download/${version}/FairfaxHD.zip";
    hash = "sha256-ZRGHPMOOLjAWaO+a06QSzWYqzMEfWYS6QjaQAJzij/E=";
    stripRoot = false;
  };

  kreativeSquare = fetchzip {
    url = "https://github.com/kreativekorp/open-relay/releases/download/${version}/KreativeSquare.zip";
    hash = "sha256-t6GbOLU4iicavxR2ZWdI9gbLSOVWbwDEFTf3gJHLy5k=";
    stripRoot = false;
  };

  installPhase = ''
    export FONT_DIR=$out/share/fonts
    mkdir -p $out/share/fonts
    cp $constructium/*.ttf $FONT_DIR
    cp $fairfax/*.ttf $FONT_DIR
    cp $fairfaxHD/*.ttf $FONT_DIR
    cp $kreativeSquare/*.ttf $FONT_DIR
  '';

  meta = {
    description = "The most general-purpose and useful fonts produced by Kreative Software.";
    homepage = "https://www.kreativekorp.com/software/fonts/index.shtml";
    license = lib.licenses.ofl;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
