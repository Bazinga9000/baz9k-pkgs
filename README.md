# Baz9k Package Repo

This repository contains a handful of NixOS packages packaged by me. You're free to use these as the basis for any inclusions in nixpkgs, just let me know if you do.

When using the overlay, all packages are prefixed with `baz9k`.

## List of packages
### `magicseteditor` and `magicseteditor-allgames`
A package of [this fork](https://github.com/G-e-n-e-v-e-n-s-i-S/MagicSetEditor2) of Magic Set Editor 2, for creating and editing custom Magic: The Gathering cards. `magicseteditor` ships with the MSE community's [Full Template Pack](https://github.com/MagicSetEditorPacks/Full-Magic-Pack) for Magic cards.

If you want to also include the similar pack for [non-Magic games](https://github.com/MagicSetEditorPacks/Full-Non-Magic-Pack), use `magicseteditor-allgames`. This is large, and the games inside work to varying levels. Since I primarily use this for Magic only, I only provide support/fixes for MSE failing to open at all due to *extremely* broken templates if you use this option. Problems with individual templates should otherwise be reported upstream.

You will also need to install `magicseteditor.fonts` or `magicseteditor-allgames.fonts` as font packages, since many templates assume fonts exist on your system. (There *is* a merged PR that allows MSE to grab fonts from its own resource directory, but as of now it does not work properly on Unix systems. Hopefully in the future this extra step won't be necessary.)

### `kreative-core-fonts`

A font package containing the four [Kreative Kore](https://www.kreativekorp.com/software/fonts/index.shtml#kore) fonts by KreativeKorp. These fonts support a wide variety of scripts along with the [Under-ConScript Unicode Registry](https://www.kreativekorp.com/ucsur/) and some other goodies.

These fonts are:
- Constructium
- Fairfax
- Fairfax HD
- Kreative Square
