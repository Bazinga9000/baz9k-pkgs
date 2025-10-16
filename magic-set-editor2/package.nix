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
  applyPatches,
  fetchpatch,

  includeNonMagicTemplates ? false
}:

stdenv.mkDerivation rec {
  pname = "magic-set-editor2";
  version = "2.5.8.78b93e5";

  src = applyPatches {
    src = fetchFromGitHub {
        owner = "G-e-n-e-v-e-n-s-i-S";
        repo = "MagicSetEditor2";
        rev = "78b93e5701d10c17448b15eb547c9752f2635322";
        hash = "sha256-HN4im29LFPAMpRPtw2l9n+2yQG+2+/CL5gQ8oFHN3Qs=";
    };

    patches = [
      (fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/G-e-n-e-v-e-n-s-i-S/MagicSetEditor2/pull/58.patch";
        hash = "sha256-6+U+gb9XQrixQHUwIk8Wc2vD0RmkMyJ+Y7+jOZIa484=";
      })
    ];

    postPatch =  ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "find_package(wxWidgets 3.3.1 CONFIG REQUIRED)" "find_package(wxWidgets 3.3.1 REQUIRED)"
    '';
  };

  # This has to be outside of applyPatches so we get set to the output's /share, not the source's
  patchPhase = ''
    substituteInPlace src/data/font.cpp \
      --replace-fail "String appPath(wxFileName(wxStandardPaths::Get().GetExecutablePath()).GetPath());" "String appPath = \"$out/share\";"
  '';

  magic_pack = fetchFromGitHub {
    owner = "MagicSetEditorPacks";
    repo = "Full-Magic-Pack";
    rev = "d2f99c2f43cbd139bd62a5c9ea429c9b641819c0";
    hash = "sha256-6h5ugg+0wypxpxD27fLFdSMKMDg987VOrHNAC2CyJ74=";
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
    wxwidgets_3_3
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

    export FONT_DIR=$out/share/fonts
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
