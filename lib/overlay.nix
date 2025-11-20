{ flake }:

/**
  Overlay function extending the Nixpkgs `lib` with Nixvim's additions.

  This function is intended to be passed to `lib.extend`.

  # Examples

  Importing the file directly:
  ```
  lib.extend (import ./overlay.nix { flake = nixvim; })
  ```

  Using the overlay from flake outputs:
  ```
  lib.extend nixvim.lib.overlay
  ```

  # Inputs

  `lib`
  : The final lib instance; the fixpoint of all extensions, including this one.

  `prevLib`
  : The lib instance prior to applying this overlay.
*/
lib: prevLib: {
  # Add Nixvim's section to the lib
  nixvim = import ./top-level.nix { inherit flake lib; };

  # Extend the maintainers set with Nixvim-specific maintainers
  maintainers = prevLib.maintainers // import ./maintainers.nix;

  # Extend lib.types with Nixvim's custom types
  types = prevLib.types // import ./types.nix { inherit lib; };
}
