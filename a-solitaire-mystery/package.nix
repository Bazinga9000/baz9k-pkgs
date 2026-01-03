{
  lib,
  stdenv,
  glibc,
  autoPatchelfHook,
  SDL2,
  love,
  makeBinaryWrapper,
  requireFile,
}:

stdenv.mkDerivation rec {
  pname = "a-solitaire-mystery";
  version = "1.5.10";

  src = requireFile {
    name = "ASM_linux.tar.gz";
    url = "https://hempuli.itch.io/a-solitaire-mystery";
    # Use `nix hash file --sri --type sha256` to get the correct hash
    hash = "sha256-JovIuVKtVy4kQ8BRgb2YP+r64GpCeexZ4lDkDJ8Riho=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    autoPatchelfHook
  ];

  installPhase = ''
    # Use nixos love libraries instead of prepackaged libraries (except libsteam/luasteam)
    mv lib/libsteam_api.so .
    rm lib/*so*
    mv libsteam_api.so lib

    # For some reason, upstream love exports its library as libliblove.so for the time being, manually introduce the right name
    # see discussion on https://github.com/NixOS/nixpkgs/pull/473153
    cp ${love}/lib/libliblove.so lib/liblove-11.5.so

    # clean up some unnecessary files
    rm ASM
    rm ASM.desktop
    rm ASM.png
    rm -r share/lua
    rm -r share/luajit-2.1

    # install
    mkdir -p $out
    cp -r ./* $out

    # patch .desktop file
    substituteInPlace \
          $out/share/applications/ASM.desktop \
          --replace-fail "ASM %f" "ASM"
  '';

  buildInputs = [
    stdenv.cc.cc.lib
    glibc
    SDL2
    love
  ];

  dontAutoPatchElf = true;

  fixupPhase = ''
    # ignore-missing is set so that liblove can get picked up dynamically from $out/lib
    autoPatchelf $out/bin/ASM --ignore-missing="liblove-11.5.so"
    wrapProgram $out/bin/ASM --append-flag "$out/ASM.love" --set "LUA_CPATH" "$out/lib/lua/5.1/?.so" --prefix LD_LIBRARY_PATH : $out/lib
  '';

  meta = {
    description = "A collection of 30 mysterious solitaires";
    homepage = "https://hempuli.itch.io/a-solitaire-mystery";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "ASM";
    platforms = lib.platforms.all;
  };
}
