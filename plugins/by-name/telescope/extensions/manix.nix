{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  telescopeHelpers = import ./_helpers.nix { inherit lib config pkgs; };
in
telescopeHelpers.mkExtension {
  name = "manix";
  package = "telescope-manix";

  settingsOptions = {
    manix_args = defaultNullOpts.mkListOf lib.types.str [ ] "CLI arguments to pass to manix.";

    cword = defaultNullOpts.mkBool false ''
      Set to `true` if you want to use the current word as the search query.
    '';
  };

  settingsExample = {
    cword = true;
  };

  extraOptions = {
    manixPackage = lib.mkPackageOption pkgs "manix" {
      nullable = true;
    };
  };

  extraConfig = cfg: {
    extraPackages = [ cfg.manixPackage ];
  };
}
