{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "kreative-kore-fonts";
  version = "2026-04-12";

  dontUnpack = true;

  constructium = fetchzip {
    url = "https://github.com/kreativekorp/open-relay/releases/download/${version}/Constructium.zip";
    hash = "sha256-G1Bu9feDFosum44r3QgNqIkClf5QkSBBnIY9gXbHHWU=";
    stripRoot = false;
  };

  fairfax = fetchzip {
    url = "https://github.com/kreativekorp/open-relay/releases/download/${version}/Fairfax.zip";
    hash = "sha256-LMe7txsuxm0HVP7Mds5Pndp604svhc+FHaJODT479nk=";
    stripRoot = false;
  };

  fairfaxHD = fetchzip {
    url = "https://github.com/kreativekorp/open-relay/releases/download/${version}/FairfaxHD.zip";
    hash = "sha256-8DKQkUb2DwqF02uYLPOa4KwLpi6nuLSycnZ65wTfVO4=";
    stripRoot = false;
  };

  kreativeSquare = fetchzip {
    url = "https://github.com/kreativekorp/open-relay/releases/download/${version}/KreativeSquare.zip";
    hash = "sha256-4yfv0VAhhDHvpqMoFbjezhwPc+UGFvR1YQjAJiuWCH0=";
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
