{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  hunspell,
  wxwidgets_3_3,
  makeBinaryWrapper,
  gtk3,
  makeDesktopItem,

  includeNonMagicTemplates ? false,
}:

stdenv.mkDerivation rec {
  pname = "magic-set-editor2";
  version = "2.5.8-unstable-2026-06-19";

  src = fetchFromGitHub {
    owner = "G-e-n-e-v-e-n-s-i-S";
    repo = "MagicSetEditor2";
    rev = "d9b58bb5eb666d53573e2c4eade5c485e7638179";
    hash = "sha256-eL6+s0rItOy0ILISb8v5pdU3CFcr58+AriO6Q2fLArM=";
  };

  # This has to be outside of applyPatches so we get set to the output's /share, not the source's
  patchPhase = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "find_package(wxWidgets 3.3.1 CONFIG REQUIRED)" "find_package(wxWidgets 3.3.1 REQUIRED)"

    substituteInPlace src/data/font.cpp \
      --replace-fail "String appPath(wxFileName(wxStandardPaths::Get().GetExecutablePath()).GetPath());" "String appPath = \"$out/share\";"
  '';

  magic_pack = fetchFromGitHub {
    owner = "MagicSetEditorPacks";
    repo = "Full-Magic-Pack";
    rev = "d5a825b6c08d5a9b092b54595a33a84facf49ae1";
    hash = "sha256-oayMOVa2ksMsHWTFPA4XcBhBOKlmTFgnK1SlvnM00Yc=";
  };

  non_magic_pack =
    if includeNonMagicTemplates then
      fetchFromGitHub {
        owner = "MagicSetEditorPacks";
        repo = "Full-Non-Magic-Pack";
        rev = "84c6722f18e0838ff4a842ad13eefb71d9a39f24";
        hash = "sha256-U8l7p/6AKzYumRGR7tYlZN9pJ90PwcOy+EB0N4lkF8I=";
      }
    else
      null;

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    boost
    hunspell
    wxwidgets_3_3
  ];

  installPhase = ''
    mkdir -p $out/bin/
    mkdir -p $TMPDIR/data
    cp -r $magic_pack/data/* $TMPDIR/data
    ${
      if includeNonMagicTemplates then
        ''
          chmod -R +w $TMPDIR/data
          cp -rn $non_magic_pack/data/* $TMPDIR/data
        ''
      else
        ""
    }
    cp -r $TMPDIR/data $out/data
    cp -r $src/resource $out
    cp magicseteditor $out/bin/magicseteditor
    wrapProgram $out/bin/magicseteditor --set WX_MAGICSETEDITOR_DATA_DIR $out --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"

    export ICON_DIR=$out/share/icons/hicolor/32x32/apps
    mkdir -p $ICON_DIR
    cp ${./icon.png} $ICON_DIR/magicseteditor.png
    cp -r ${desktopItem}/share $out

    export FONT_DIR=$out/share/fonts
    mkdir -p $FONT_DIR
    mkdir -p $TMPDIR/fonts
    find $magic_pack/Magic\ -\ Fonts -iname '*.ttf' -exec cp -n \{\} $TMPDIR/fonts \;
    ${
      if includeNonMagicTemplates then
        ''
          find $non_magic_pack/Other\ -\ Fonts -iname '*.ttf' -exec cp -n \{\} $TMPDIR/fonts \;
        ''
      else
        ""
    }
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
