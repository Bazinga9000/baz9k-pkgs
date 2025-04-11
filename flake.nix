{
  description = "An overlay of miscellaneous packages.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    flake-compat,
  }: {
    overlays.default = (final: prev: {
      baz9k = {
        magicseteditor = prev.callPackage ./magic-set-editor2/package.nix {includeNonMagicTemplates = false;};
        magicseteditor-allgames = prev.callPackage ./magic-set-editor2/package.nix {includeNonMagicTemplates = true;};
      };
    }
  );
}
