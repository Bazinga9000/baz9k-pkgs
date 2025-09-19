{
  lib,
  stdenv,
  fetchzip
}:

stdenv.mkDerivation rec {
  pname = "kreative-kore-fonts";
  version = "2025-09-01";

  dontUnpack = true;

  constructium = fetchzip {
    url = "https://github.com/kreativekorp/open-relay/releases/download/${version}/Constructium.zip";
    hash = "sha256-Fti/i01fjRJOLBkDwxvX0/ndoJmmqHS/vl+KMGeEYFE=";
    stripRoot = false;
  };

  fairfax = fetchzip {
    url = "https://github.com/kreativekorp/open-relay/releases/download/${version}/Fairfax.zip";
    hash = "sha256-T31Tvp1LpTH3me9v+MoV9pC+p3bbBCLvLR83UBBv8Ck=";
    stripRoot = false;
  };

  fairfaxHD = fetchzip {
    url = "https://github.com/kreativekorp/open-relay/releases/download/${version}/FairfaxHD.zip";
    hash = "sha256-8ms8qnsXKcZr7uAZD3ZgU4ou63QXAW+jkFiOah6n04Y=";
    stripRoot = false;
  };

  kreativeSquare = fetchzip {
    url = "https://github.com/kreativekorp/open-relay/releases/download/${version}/KreativeSquare.zip";
    hash = "sha256-QFWHF8dUUS+TAIHFDmtbdM/GqFJLjTfGJvRiUcVjpW0=";
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
