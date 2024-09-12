{
  system,
  nixpkgs,
}:
let
  # FIXME:
  # Building the docs evaluates many package-option defaults, some of which are unfree.
  # This usually happens when we include the package option value in another option's default without
  # using a literalExpression defaultText.
  config = {
    allowUnfree = true;
  };

  # Extend nixpkg's lib, so that we can handle recursive leaf types such as `either`
  libOverlay = final: prev: {
    types = prev.types // {
      either =
        t1: t2:
        prev.types.either t1 t2
        // {
          getSubOptions = prefix: t1.getSubOptions prefix // t2.getSubOptions prefix;
        };
    };
  };

  # Extended nixpkgs instance, with patches to nixos-render-docs
  overlay = final: prev: {
    lib = prev.lib.extend libOverlay;

    nixos-render-docs = prev.nixos-render-docs.overrideAttrs (old: {
      patches = old.patches or [ ] ++ [
        # Adds support for GFM-style admonitions in rendered commonmark
        ./0001-Output-GFM-admonition.patch
        # TODO:add support for _parsing_ GFM admonitions too
        # https://github.com/nix-community/nixvim/issues/2217
      ];
    });
  };

in
import nixpkgs {
  inherit config system;
  overlays = [ overlay ];
}
