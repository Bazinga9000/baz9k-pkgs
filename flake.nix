{
  description = "An overlay of miscellaneous packages.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-compat,
    }:
    {
      overlays.default = (
        final: prev: {
          baz9k = {
            magicseteditor =
              prev.callPackage ./magic-set-editor2/package.nix { includeNonMagicTemplates = false; }
              // {
                all = prev.callPackage ./magic-set-editor2/package.nix { includeNonMagicTemplates = true; };
              };

            kreative-kore-fonts = prev.callPackage ./kreative-fonts/package.nix { };

            cambridge = prev.callPackage ./cambridge/package.nix { };

            a-solitaire-mystery = prev.callPackage ./a-solitaire-mystery/package.nix { };

            microwave = prev.callPackage ./microwave/package.nix { };

            nsmb-mariovsluigi = prev.callPackage ./nsmb-mariovsluigi/package.nix { };
          };
        }
      );
    };
}
