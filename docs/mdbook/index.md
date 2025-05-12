# NixVim - A Neovim configuration system for nix

## Other versions of these docs

Please ensure you are referencing documentation that corresponds to the Nixvim version you are using!

Documentation is currently available for the following versions:

@DOCS_VERSIONS@

## Recent Breaking Changes

> [!CAUTION]
> By default, Nixvim now constructs its own instance of nixpkgs, using the revision from our flake.lock.
> This change was largely motivated by: [How do I solve "`<name>` cannot be found in `pkgs`"](./user-guide/faq.html#how-do-i-solve-name-cannot-be-found-in-pkgs)
>
> The old behaviour can be restored by enabling `nixpkgs.useGlobalPackages`.
>
> If your flake modifies the `nixpkgs` through `follows` this can still cause issues by changing the expected `nixpkg` `nixvim` was tested & built against.

@README@

## Welcome to the docs!

Over to the left, you'll find the sidebar. There you'll see several "User guides" (including an [FAQ](./user-guide/faq.md)), along with pages for various "options".

While you can search our main docs using the <i class="fa fa-search"></i> icon, if you're looking for a specific option you may find the dedicated [Nixvim Option Search](./search/index.html) (at the bottom of the sidebar) has more relevant results.

> [!TIP]
> Any page with a ❱ icon next to it has one-or-more _sub-pages_.

