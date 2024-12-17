{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blink-compat";
  packPathName = "blink.compat";
  package = "blink-compat";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    impersonate_nvim_cmp = defaultNullOpts.mkBool false ''
      Whether to impersonate nvim-cmp

      Some plugins lazily register their completion source when nvim-cmp is
      loaded, so pretend that we are nvim-cmp, and that nvim-cmp is loaded.
      most plugins don't do this, so this option should rarely be needed.
    '';

    debug = defaultNullOpts.mkBool false ''
      Whether to enable debug mode. Might be useful for troubleshooting.
    '';
  };

  settingsExample = {
    impersonate_nvim_cmp = true;
    debug = false;
  };
}
