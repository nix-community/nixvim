{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-trailspace";
  moduleName = "mini.trailspace";
  packPathName = "mini.trailspace";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    only_in_normal_buffers = defaultNullOpts.mkBool true ''
      Highlight only in normal buffers (ones with empty 'buftype').
      This is useful to not show trailing whitespace where it usually doesn't matter.
    '';
  };

  settingsExample = {
    only_in_normal_buffers = false;
  };
}
