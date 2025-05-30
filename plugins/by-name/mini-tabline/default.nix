{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-tabline";
  moduleName = "mini.tabline";
  packPathName = "mini.tabline";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    format = defaultNullOpts.mkRaw "nil" ''
      Function which formats the tab label.
      By default surrounds with space and possibly prepends with icon.
    '';

    show_icons = defaultNullOpts.mkBool true ''
      Whether to show file icons (requires 'mini.icons').
    '';

    tabpage_section = defaultNullOpts.mkEnum [ "left" "right" "none" ] "left" ''
      Where to show tabpage section in case of multiple vim tabpages.
    '';
  };

  settingsExample = {
    show_icons = false;
    tabpage_section = "right";
  };
}
