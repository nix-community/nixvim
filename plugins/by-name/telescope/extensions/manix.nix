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

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = [
        "telescope"
        "extensions"
        "manix"
      ];
      packageName = "manix";
    })
  ];

  settingsOptions = {
    manix_args = defaultNullOpts.mkListOf lib.types.str [ ] "CLI arguments to pass to manix.";

    cword = defaultNullOpts.mkBool false ''
      Set to `true` if you want to use the current word as the search query.
    '';
  };

  settingsExample = {
    cword = true;
  };

  extraConfig = {
    dependencies.manix.enable = lib.mkDefault true;
  };
}
