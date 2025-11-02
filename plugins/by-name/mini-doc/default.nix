{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-doc";
  moduleName = "mini.doc";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    annotation_pattern = "^%-%-%-(%S*) ?";
    default_section_id = "@text";
    script_path = "scripts/minidoc.lua";
    silent = true;
  };
}
