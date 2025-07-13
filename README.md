# Baz9k Package Repo

This repository contains a handful of NixOS packages packaged by me. You're free to use these as the basis for any inclusions in nixpkgs, just let me know if you do.

When using the overlay, all packages are prefixed with `baz9k`.

## List of packages
### `magicseteditor` and `magicseteditor.all`
A package of [this fork](https://github.com/G-e-n-e-v-e-n-s-i-S/MagicSetEditor2) of Magic Set Editor 2, for creating and editing custom Magic: The Gathering cards. `magicseteditor` ships with the MSE community's [Full Template Pack](https://github.com/MagicSetEditorPacks/Full-Magic-Pack) for Magic cards.

If you want to also include the similar pack for [non-Magic games](https://github.com/MagicSetEditorPacks/Full-Non-Magic-Pack), use `magicseteditor.all`. This is large, and the games inside work to varying levels. Since I primarily use this for Magic only, I only provide support/fixes for MSE failing to open at all due to *extremely* broken templates if you use this option. Problems with individual templates should otherwise be reported upstream.

### `kreative-core-fonts`

A font package containing the four [Kreative Kore](https://www.kreativekorp.com/software/fonts/index.shtml#kore) fonts by KreativeKorp. These fonts support a wide variety of scripts along with the [Under-ConScript Unicode Registry](https://www.kreativekorp.com/ucsur/) and some other goodies.

These fonts are:
- Constructium
- Fairfax
- Fairfax HD
- Kreative Square

### `cambridge`

The block stacking game [Cambridge](https://github.com/cambridge-stacker/cambridge).

Modpacks can be installed into `~/.local/share/love/cambridge/` as usual.

### `a-solitaire-mystery`

The itch.io version of Hempuli's [A Solitaire Mystery](https://hempuli.itch.io/a-solitaire-mystery).

Requires `ASM_linux.tar.gz` in your nix-store. Download it from itch.io and run `nix-store --add-fixed sha256 ./ASM_linux.tar.gz` to add it to the nix store.
