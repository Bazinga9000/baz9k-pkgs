{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  hunspell,
  wxGTK32,
  makeBinaryWrapper,
  gtk3,
  makeDesktopItem,

  includeNonMagicTemplates ? false
}:

stdenv.mkDerivation rec {
  pname = "magic-set-editor2";
  version = "2.5.6";

  src = fetchFromGitHub {
    owner = "haganbmj";
    repo = "MagicSetEditor2";
    rev = "v${version}";
    hash = "sha256-LD2LVa/BAQ261IPJFaQIok3SutISDf7fbp32iDWynqY=";
  };

  magic_pack = fetchFromGitHub {
    owner = "MagicSetEditorPacks";
    repo = "Full-Magic-Pack";
    rev = "45f6116c3abeade7fdcc526b84e4dd0b845a5429";
    hash = "sha256-fDPPSkZQ2X2qr9YU+xrC+3Y5tobBniXi1k8xItAzAjQ=";
  };

  non_magic_pack = if includeNonMagicTemplates then fetchFromGitHub {
    owner = "MagicSetEditorPacks";
    repo = "Full-Non-Magic-Pack";
    rev = "e9dfb6280967230c66d2eb6a027708d99bb66df2";
    hash = "sha256-RJyP3yO99FjC4ZN8j5TloZhBiTmIu+ZhgbYz/pXkld8=";
  } else null;

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    boost
    hunspell
    wxGTK32
  ];

  installPhase = ''
    mkdir -p $out/bin/
    mkdir -p $TMPDIR/data
    cp -r $magic_pack/data/* $TMPDIR/data
    ${if includeNonMagicTemplates then ''
      chmod -R +w $TMPDIR/data
      cp -rn $non_magic_pack/data/* $TMPDIR/data
      chmod +w $TMPDIR/data/PACG.mse-game/game
      cp ${./PACG_fixed} $TMPDIR/data/PACG.mse-game/game
    '' else ""}
    cp -r $TMPDIR/data $out/data
    cp -r $src/resource $out
    cp magicseteditor $out/bin/magicseteditor
    wrapProgram $out/bin/magicseteditor --set WX_MAGICSETEDITOR_DATA_DIR $out --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"

    export ICON_DIR=$out/share/icons/hicolor/32x32/apps
    mkdir -p $ICON_DIR
    cp ${./icon.png} $ICON_DIR/magicseteditor.png
    cp -r ${desktopItem}/share $out
  '';

  desktopItem = makeDesktopItem {
    name = "Magic Set Editor";
    exec = "magicseteditor";
    comment = meta.description;
    desktopName = "Magic Set Editor";
    genericName = "Magic Set Editor";
    icon = "magicseteditor";
    categories = [ "Game" ];
  };

  passthru = {
    fonts = stdenvNoCC.mkDerivation {
      src = magic_pack;
      non_magic = non_magic_pack;

      name = "mse-fonts";
      dontConfigure = true;

      installPhase = ''
        mkdir -p $out/share/fonts
        mkdir -p $TMPDIR/fonts
        find $src/Magic\ -\ Fonts -iname '*.ttf' -exec cp -n \{\} $TMPDIR/fonts \;
        ${if includeNonMagicTemplates then ''
          find $non_magic/Other\ -\ Fonts -iname '*.ttf' -exec cp -n \{\} $TMPDIR/fonts \;
        '' else ""}
        cp $TMPDIR/fonts/* $out/share/fonts
      '';

      meta.description = "Required fonts for Magic Set Editor";
    };
  };

  meta = {
    description = "Magic Set Editor is a program for designing trading cards";
    homepage = "https://github.com/haganbmj/MagicSetEditor2";
    changelog = "https://github.com/haganbmj/MagicSetEditor2/blob/${src.rev}/CHANGES.md";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    mainProgram = "magic-set-editor2";
    platforms = lib.platforms.all;
  };
}
