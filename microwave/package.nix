{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  vulkan-loader,
  libX11,
  libXcursor,
  libxcb,
  libXi,
  libxkbcommon,
  wayland,
  stdenv,
  darwin,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "microwave";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "Woyten";
    repo = "tune";
    rev = "microwave-${version}";
    hash = "sha256-Op7gnPE7PwjhczrxHDBYzxRozUG0QoeyhzzhoJKPmbs=";
  };

  cargoHash = "sha256-BqE928YZvn+Jqg4ijx4wXDYBT+5K24v8WfdBy1zD2rk=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildAndTestSubdir = "microwave";

  # The midi::tests require a working ALSA sequencer, which isn't available in the build sandbox
  checkFlags = [
    "--skip"
    "midi::tests"
  ];

  buildInputs = [
    udev
    vulkan-loader
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreAudio
    darwin.apple_sdk.frameworks.CoreGraphics
    darwin.apple_sdk.frameworks.IOKit
    darwin.apple_sdk.frameworks.Metal
    darwin.apple_sdk.frameworks.QuartzCore
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libX11
    libXcursor
    libxcb
    libXi
    libxkbcommon
    wayland
  ];

  # todo: figure out a better way to deal with the font dependency
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/bin/assets
    cp ${./FiraSans-Regular.ttf} $out/bin/assets/FiraSans-Regular.ttf

    patchelf $out/bin/microwave \
      --add-rpath ${
        lib.makeLibraryPath [
          vulkan-loader
          libX11
          libxkbcommon
          wayland
        ]
      }
  '';

  meta = {
    description = "Make xenharmonic music and create synthesizer tuning files for microtonal scales";
    homepage = "https://github.com/Woyten/tune/tree/main/microwave";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "microwave";
  };
}
