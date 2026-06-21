{
  lib,
  stdenv,
  fetchzip,
  nerd-font-patcher,
  makeNerdFont ? false,
}:

stdenv.mkDerivation rec {
  pname = "kreative-kore-fonts${lib.optionalString makeNerdFont "-nerdfont"}";
  version = "2026-05-08";

  dontUnpack = true;

  nativeBuildInputs = lib.optional makeNerdFont nerd-font-patcher;

  constructium = fetchzip {
    url = "https://github.com/kreativekorp/open-relay/releases/download/${version}/Constructium.zip";
    hash = "sha256-G1Bu9feDFosum44r3QgNqIkClf5QkSBBnIY9gXbHHWU=";
    stripRoot = false;
  };

  fairfax = fetchzip {
    url = "https://github.com/kreativekorp/open-relay/releases/download/${version}/Fairfax.zip";
    hash = "sha256-6wwC12ATWapSCCcLMs5d478kFE6NAZRLwpzOw2G9OZo=";
    stripRoot = false;
  };

  fairfaxHD = fetchzip {
    url = "https://github.com/kreativekorp/open-relay/releases/download/${version}/FairfaxHD.zip";
    hash = "sha256-9AMveEqFx9rdxYI5d4sbVZj7QJtH9ImelOfOqlDZ5UI=";
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
    runHook postInstall
  '';

  postInstall = lib.optionalString makeNerdFont ''
    export HOME=$(mktemp -d)
    TMP_PATCH_DIR=$(mktemp -d)
    echo "Patching fonts with Nerd Font Patcher."
    for font in $out/share/fonts/*.ttf; do
      nerd-font-patcher -c --no-progressbars "$font" --out "$TMP_PATCH_DIR"
    done
    rm $out/share/fonts/*.ttf
    mv "$TMP_PATCH_DIR"/*.ttf $out/share/fonts/
  '';

  meta = {
    description = "The most general-purpose and useful fonts produced by Kreative Software.";
    homepage = "https://www.kreativekorp.com/software/fonts/index.shtml";
    license = lib.licenses.ofl;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
