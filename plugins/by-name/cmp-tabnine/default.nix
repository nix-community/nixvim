{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "cmp-tabnine";
  description = "[TabNine](https://tabnine.com) completion source for the nvim-cmp.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  imports = [
    { cmpSourcePlugins.cmp_tabnine = "cmp-tabnine"; }
  ];

  deprecateExtraOptions = true;

  moduleName = "cmp_tabnine.config";
  setup = ":setup";

  settingsOptions = {
    max_lines = defaultNullOpts.mkUnsignedInt 1000 ''
      How many lines of buffer context to pass to TabNine.
    '';

    max_num_results = defaultNullOpts.mkUnsignedInt 20 ''
      How many results to return.
    '';

    sort = defaultNullOpts.mkBool true ''
      Sort results by returned priority.
    '';

    run_on_every_keystroke = defaultNullOpts.mkBool true ''
      Generate new completion items on every keystroke.

      For more info, check out [#18](https://github.com/tzachar/cmp-tabnine/issues/18).
    '';

    snippet_placeholder = defaultNullOpts.mkStr ".." ''
      Indicates where the cursor will be placed in case a completion item is asnippet.
      Any string is accepted.

      For this to work properly, you need to setup snippet support for `nvim-cmp`.
    '';

    ignored_file_types = defaultNullOpts.mkAttrsOf' {
      type = types.bool;
      pluginDefault = { };
      example = {
        lua = true;
      };
      description = ''
        Which file types to ignore.
      '';
    };

    min_percent = defaultNullOpts.mkNullable (types.numbers.between 0 100) 0 ''
      Eliminate items with a percentage less than `min_percent`.
    '';
  };

  settingsExample = {
    max_lines = 600;
    max_num_results = 10;
    sort = false;
  };
}
