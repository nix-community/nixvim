{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;

  mkExtension = import ./_mk-extension.nix;
in
mkExtension {
  name = "manix";
  package = "telescope-manix";

  dependencies = [ "manix" ];

  settingsOptions = {
    manix_args = defaultNullOpts.mkListOf lib.types.str [ ] "CLI arguments to pass to manix.";

    cword = defaultNullOpts.mkBool false ''
      Set to `true` if you want to use the current word as the search query.
    '';
  };

  settingsExample = {
    cword = true;
  };
}
