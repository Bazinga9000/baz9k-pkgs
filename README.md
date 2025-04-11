# Baz9k Package Repo

This repository contains a handful of NixOS packages packaged by me. You're free to use these as the basis for any inclusions in nixpkgs, just let me know if you do.


## List of packages
### `magicseteditor` and `magicseteditor-allgames`
A package of [this fork](https://github.com/haganbmj/MagicSetEditor2/tree/6b0d311dc983a1c85790ee3027bf0050a91e5351) of Magic Set Editor 2, for creating and editing custom Magic: The Gathering cards. `magicseteditor` ships with the MSE community's [Full Template Pack](https://github.com/MagicSetEditorPacks/Full-Magic-Pack) for Magic cards.

If you want to also include the similar pack for [non-Magic games](https://github.com/MagicSetEditorPacks/Full-Non-Magic-Pack), use `magicseteditor-allgames`. This is large, and the games inside work to varying levels. Since I primarily use this for Magic only, I only provide support/fixes for MSE failing to open at all due to *extremely* broken templates if you use this option. Problems with individual templates should otherwise be reported upstream.

You will also need to install `magicseteditor.fonts` or `magicseteditor-allgames.fonts` as font packages, since many templates assume fonts exist on your system.
