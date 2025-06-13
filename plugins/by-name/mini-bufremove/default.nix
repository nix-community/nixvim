{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-bufremove";
  moduleName = "mini.bufremove";
  packPathName = "mini.bufremove";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    silent = defaultNullOpts.mkBool false ''
      Whether to disable showing non-error feedback.
    '';
  };

  settingsExample = {
    silent = true;
  };
}
