{ lib
, stdenv
, fetchzip
, autoPatchelfHook
, gtk3
, zlib
, alsa-lib
, dbus
, libGL
, libXcursor
, libXext
, libXi
, libXinerama
, libxkbcommon
, libXrandr
, libXScrnSaver
, libXxf86vm
, udev
, vulkan-loader # (not used by default, enable in settings menu)
, wayland # (not used by default, enable with SDL_VIDEODRIVER=wayland - doesn't support HiDPI)
, makeDesktopItem
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nsmb-mariovsluigi";
  version = "2.0.4.1";

  src = fetchzip {
    url = "https://github.com/ipodtouch0218/NSMB-MarioVsLuigi/releases/download/v${finalAttrs.version}/MarioVsLuigi-Linux-v${finalAttrs.version}.zip";
    hash = "sha256-KgJN7hJSbR/G6rGObbMzF1iTkiM3vAY3+TJNvLPMZYU=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    # Load-time libraries (loaded from DT_NEEDED section in ELF binary)
    alsa-lib
    gtk3
    stdenv.cc.cc.lib
    zlib

    # Run-time libraries (loaded with dlopen)
    dbus
    libGL
    libXcursor
    libXext
    libXi
    libXinerama
    libxkbcommon
    libXrandr
    libXScrnSaver
    libXxf86vm
    udev
    vulkan-loader
    wayland
  ];

  desktopItem = makeDesktopItem {
    name = "nsmb-mariovsluigi";
    desktopName = "NSMB Mario VS. Luigi";
    comment = finalAttrs.meta.description;
    icon = "nsmb-mariovsluigi";
    exec = "nsmb-mariovsluigi";
    categories = [ "Game" ];
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 linux.x86_64 "$out/bin/nsmb-mariovsluigi"
    mkdir -p "$out/libexec/nsmb-mariovsluigi"
    install -Dm644 *.so* "$out/libexec/nsmb-mariovsluigi/"

    mkdir -p "$out/share"
    cp -r linux_Data "$out/share/nsmb-mariovsluigi"
    ln -s "$out/share/nsmb-mariovsluigi" "$out/bin/nsmb-mariovsluigi_Data"
    export ICON_DIR=$out/share/icons/hicolor/512x512/apps
    mkdir -p $ICON_DIR
    cp "$out/share/nsmb-mariovsluigi/Resources/UnityPlayer.png" "$ICON_DIR/nsmb-mariovsluigi.png"
    install -Dm644 "$desktopItem/share/applications/nsmb-mariovsluigi.desktop" "$out/share/applications/nsmb-mariovsluigi.desktop"

    runHook postInstall
  '';

  # Patch required run-time libraries as load-time libraries
  postFixup = ''
    patchelf \
      --add-needed libasound.so.2 \
      --add-needed libdbus-1.so.3 \
      --add-needed libGL.so.1 \
      --add-needed libpthread.so.0 \
      --add-needed libudev.so.1 \
      --add-needed libvulkan.so.1 \
      --add-needed libwayland-client.so.0 \
      --add-needed libwayland-cursor.so.0 \
      --add-needed libwayland-egl.so.1 \
      --add-needed libX11.so.6 \
      --add-needed libXcursor.so.1 \
      --add-needed libXext.so.6 \
      --add-needed libXi.so.6 \
      --add-needed libXinerama.so.1 \
      --add-needed libxkbcommon.so.0 \
      --add-needed libXrandr.so.2 \
      --add-needed libXss.so.1 \
      --add-needed libXxf86vm.so.1 \
      "$out/libexec/nsmb-mariovsluigi/UnityPlayer.so" \
      "$out/libexec/nsmb-mariovsluigi/libdecor-cairo.so" \
      "$out/libexec/nsmb-mariovsluigi/libdecor-0.so.0" \
  '';

  meta = with lib; {
    description = "Standalone Unity remake of New Super Mario Bros DS' multiplayer gamemode, \"Mario vs Luigi\"";
    homepage = "https://github.com/ipodtouch0218/NSMB-MarioVsLuigi";
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
})
