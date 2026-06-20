{
  stdenv,
  lib,
  fetchurl,
  buildFHSEnv,
  makeDesktopItem,
}:

let
  pname = "mvlo-modloader";
  version = "6";

  unwrapped = stdenv.mkDerivation {
    pname = "${pname}-unwrapped";
    inherit version;

    src = fetchurl {
      url = "https://github.com/vlcoo/MvLO-ModLoader/releases/download/v${version}/MvLOMLLinux.x86_64";
      sha256 = "a726483c31058e3d94c7b7e01811caf2bb9e64c07963f14d837ed899af858838";
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/mvlo-modloader
      chmod +x $out/bin/mvlo-modloader
    '';
  };

in
buildFHSEnv {
  name = pname;

  runScript = "${unwrapped}/bin/mvlo-modloader";

  profile = ''
    export WINEPREFIX="$HOME/.local/share/mvlo-modloader/wine"
    mkdir -p $WINEPREFIX
  '';

  targetPkgs =
    pkgs: with pkgs; [
      # Dependencies required by MVLO
      alsa-lib
      gtk3
      zlib
      dbus
      libGL
      libXcursor
      libXext
      libXi
      libXinerama
      libXrandr
      libXScrnSaver
      libXxf86vm
      libX11
      libXrender
      libXfixes
      libxkbcommon
      udev
      vulkan-loader
      wayland
      stdenv.cc.cc.lib

      # Dependencies required by the Modloader
      icu
      fontconfig
      wineWow64Packages.stable
    ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${
      makeDesktopItem {
        name = "MvLO-ModLoader";
        exec = "mvlo-modloader";
        desktopName = "MvLO ModLoader";
        comment = "Mod Loader for Mario vs Luigi Online";
        categories = [ "Game" ];
      }
    }/share/applications/* $out/share/applications/
  '';

  meta = with lib; {
    description = "A simple way to keep your Mario vs Luigi Online mods organized and up to date";
    homepage = "https://github.com/vlcoo/MvLO-ModLoader";
    license = licenses.gpl3Only;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "mvlo-modloader";
  };
}
