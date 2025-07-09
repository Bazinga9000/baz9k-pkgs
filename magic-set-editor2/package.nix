{
  lib,
  stdenv,
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
  version = "2.5.8";

  src = fetchFromGitHub {
    owner = "G-e-n-e-v-e-n-s-i-S";
    repo = "MagicSetEditor2";
    rev = "026400a1e092eca2b98360398fa78a22f532b780";
    hash = "sha256-JCX+2yEfut7zEgcr7ugfoal8vP3MeLiuxHhJ0Ihy9KU=";
  };

  magic_pack = fetchFromGitHub {
    owner = "MagicSetEditorPacks";
    repo = "Full-Magic-Pack";
    rev = "add2e3b9796547c4cbe80e93965679cc484a7489";
    hash = "sha256-Kh03WWNYJVBaByDarFmRqSyg0z1I3/d5Svwh9LLwuZE=";
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

  patchPhase = ''
    substituteInPlace src/data/font.cpp \
      --replace-fail "fontsDirectoryPath = appPath + pathSeparator + fontsDirectoryPath + (fontsDirectoryPath.EndsWith(pathSeparator) ? wxString() : pathSeparator);" "fontsDirectoryPath = \"$out/mse-fonts/\";"
  '';

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

    export FONT_DIR=$out/mse-fonts
    mkdir -p $FONT_DIR
    mkdir -p $TMPDIR/fonts
    find $magic_pack/Magic\ -\ Fonts -iname '*.ttf' -exec cp -n \{\} $TMPDIR/fonts \;
    ${if includeNonMagicTemplates then ''
      find $non_magic_pack/Other\ -\ Fonts -iname '*.ttf' -exec cp -n \{\} $TMPDIR/fonts \;
    '' else ""}
    cp $TMPDIR/fonts/* $FONT_DIR
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

  meta = {
    description = "A program for designing trading cards";
    homepage = "https://github.com/G-e-n-e-v-e-n-s-i-S/MagicSetEditor2";
    changelog = "https://github.com/G-e-n-e-v-e-n-s-i-S/MagicSetEditor2/blob/${src.rev}/CHANGES.md";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    mainProgram = "magic-set-editor2";
    platforms = lib.platforms.all;
  };
}
