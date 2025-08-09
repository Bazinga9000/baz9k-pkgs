{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  vulkan-loader,
  xorg,
  libxkbcommon,
  stdenv,
  darwin,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "microwave";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "Woyten";
    repo = "tune";
    rev = version;
    hash = "sha256-iVIncHhmSQ+Gcz8Mt4Cx+Q7sbDl4tZ+ynOIxlnsfPdE=";
  };

  cargoHash = "sha256-JXMeAOd2bKUtF9Kut8aS2xpooR1CVxbBxPzk62nJCr0=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildAndTestSubdir = "microwave";

  buildInputs = [
    udev
    vulkan-loader
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreAudio
    darwin.apple_sdk.frameworks.CoreGraphics
    darwin.apple_sdk.frameworks.IOKit
    darwin.apple_sdk.frameworks.Metal
    darwin.apple_sdk.frameworks.QuartzCore
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
    xorg.libX11
    xorg.libXcursor
    xorg.libxcb
    xorg.libXi
    libxkbcommon
  ];

  # todo: figure out a better way to deal with the font dependency
  postFixup = lib.optionalString stdenv.isLinux ''
    mkdir -p $out/bin/assets
    cp ${./FiraSans-Regular.ttf} $out/bin/assets/FiraSans-Regular.ttf

    patchelf $out/bin/microwave \
      --add-rpath ${lib.makeLibraryPath [ vulkan-loader xorg.libX11 libxkbcommon ]}
  '';

  meta = {
    description = "Make xenharmonic music and create synthesizer tuning files for microtonal scales";
    homepage = "https://github.com/Woyten/tune/tree/main/microwave";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "microwave";
  };
}
