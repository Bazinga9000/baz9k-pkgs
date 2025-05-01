{
  lib,
  stdenv,
  fetchFromGitHub,
  love,
  zip,
  runtimeShell,
  makeDesktopItem
}:

stdenv.mkDerivation rec {
  pname = "cambridge";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "cambridge-stacker";
    repo = "cambridge";
    rev = "v${version}";
    hash = "sha256-hSu3j9tSDnFDz9jqPXCGUoSI9u7nMzjGgVQnlXEFsRY=";
  };

  buildInputs = [
    love
    zip
  ];

  desktopItem = makeDesktopItem {
    name = "Cambridge";
    exec = "cambridge";
    comment = meta.description;
    desktopName = "Cambridge";
    genericName = "Cambridge";
    icon = "cambridge";
    categories = [ "Game" ];
  };

  installPhase = let runScript = ''
    #!${runtimeShell}
    love $out/cambridge.love
  ''; in
  ''
    mkdir -p $out/bin
    cd $src
    zip -r $out/cambridge.love libs load res scene tetris conf.lua main.lua scene.lua funcs.lua
    mkdir -p $out/libs
    cp -r $src/libs/discord-rpc.* $out/libs
    echo -n "${runScript}" > $out/bin/cambridge
    chmod +x $out/bin/cambridge

    export ICON_DIR=$out/share/icons/hicolor/48x48/apps
    mkdir -p $ICON_DIR
    cp $src/res/img/cambridge_transparent.png $ICON_DIR/cambridge.png
    cp -r ${desktopItem}/share $out
  '';

  meta = {
    description = "The next open source block stacking game";
    homepage = "https://github.com/cambridge-stacker/cambridge";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "cambridge";
    platforms = lib.platforms.all;
  };
}
