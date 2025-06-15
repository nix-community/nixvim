{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-cursorword";
  moduleName = "mini.cursorword";
  packPathName = "mini.cursorword";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    delay = defaultNullOpts.mkNum 100 ''
      Delay (in ms) between when cursor moved and when highlighting appeared.
    '';
  };

  settingsExample = {
    delay = 50;
  };
}
