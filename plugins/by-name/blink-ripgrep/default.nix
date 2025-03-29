{ lib, ... }:
let
  name = "blink-ripgrep";
in
lib.nixvim.plugins.mkNeovimPlugin {
  inherit name;
  packPathName = "blink-ripgrep.nvim";
  package = "blink-ripgrep-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  imports = [
    (lib.nixvim.modules.mkBlinkPluginModule {
      pluginName = name;
      # TODO: compute a sane-default
      key = "ripgrep";
      sourceName = "Ripgrep";
      module = "blink-ripgrep";
      settingsExample = {
        async = true;
        score_offset = 100;
      };
    })
  ];

  settingsExample = {
    prefix_min_len = 3;
    context_size = 5;
    max_filesize = "1M";
    project_root_marker = ".git";
    project_root_fallback = true;
    search_casing = "--ignore-case";
    additional_rg_options = { };
    fallback_to_regex_highlighting = true;
    ignore_paths = { };
    additional_paths = { };
    debug = false;
  };

  # Configured through blink-cmp
  callSetup = false;
  hasLuaConfig = false;
}
