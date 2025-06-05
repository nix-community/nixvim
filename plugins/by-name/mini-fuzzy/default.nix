{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-fuzzy";
  moduleName = "mini.fuzzy";
  packPathName = "mini.fuzzy";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    cutoff = defaultNullOpts.mkPositiveInt 100 ''
      Maximum allowed value of match features (width and first match).
      All feature values greater than cutoff can be considered "equally bad".
    '';
  };

  settingsExample = {
    cutoff = 50;
  };
}
