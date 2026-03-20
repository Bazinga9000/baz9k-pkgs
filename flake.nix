{
  description = "An overlay of miscellaneous packages.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    # Input for uiua-git mirror
    uiua = {
      url = "github:uiua-lang/uiua";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Inputs for noctalia-git-calendar mirror
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };

    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {

        systems = [
          "x86_64-linux"
          # If anyone's out there using this flake on any other system type, feel free to PR in other systems you might need.
          # I can't verify that these builds work on such systems, which is why they aren't already here.
        ];

        imports = [
          inputs.flake-parts.flakeModules.easyOverlay
        ];

        perSystem =
          {
            config,
            pkgs,
            system,
            ...
          }:
          {
            overlayAttrs = config.packages;

            packages = {
              magicseteditor = pkgs.callPackage ./magic-set-editor2/package.nix {
                includeNonMagicTemplates = false;
              };
              magicseteditor-all = pkgs.callPackage ./magic-set-editor2/package.nix {
                includeNonMagicTemplates = true;
              };
              kreative-kore-fonts = pkgs.callPackage ./kreative-fonts/package.nix { };
              cambridge = pkgs.callPackage ./cambridge/package.nix { };
              a-solitaire-mystery = pkgs.callPackage ./a-solitaire-mystery/package.nix { };
              microwave = pkgs.callPackage ./microwave/package.nix { };
              nsmb-mariovsluigi = pkgs.callPackage ./nsmb-mariovsluigi/package.nix { };

              # Mirrors
              uiua-git = inputs.uiua.packages.${system}.default;
              noctalia-git-calendar =
                inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override
                  {
                    calendarSupport = true;
                  };
            };
          };
      }
    );
}
