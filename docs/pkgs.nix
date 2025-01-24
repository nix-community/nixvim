{
  system,
  nixpkgs,
}:
let
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
      propagatedBuildInputs = old.propagatedBuildInputs ++ [
        (final.python3.pkgs.callPackage ./gfm-alerts-to-admonitions {
          # Use the same override as `nixos-render-docs` does, to avoid "duplicate dependency" errors
          markdown-it-py = final.python3.pkgs.markdown-it-py.overridePythonAttrs { doCheck = false; };
        })
      ];

      patches = old.patches or [ ] ++ [
        # Adds support for GFM-style admonitions in rendered commonmark
        ./0001-nixos-render-docs-Output-GFM-admonition.patch
        # Adds support for parsing GFM-style admonitions
        ./0002-nixos-render-docs-Support-gfm-style-admonitions.patch
      ];
    });
  };

in
import nixpkgs {
  inherit system;
  overlays = [ overlay ];
}
