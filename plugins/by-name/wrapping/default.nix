{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "wrapping";
  package = "wrapping-nvim";
  description = "Plugin to make it easier to switch between 'soft' and 'hard' line wrapping in NeoVim.";

  maintainers = [ lib.maintainers.ZainKergaye ];

  settingsOptions = {
    notify_on_switch = defaultNullOpts.mkBool true ''
      By default, wrapping.nvim will output a message to the
      command line when the hard or soft mode is set.
    '';

    create_commands = defaultNullOpts.mkBool true ''
      If true, the plugin will create the following
      commands to set/override a wrapping mode in case
      it is not autodetected correctly:

      * 'HardWrapMode'

      * 'SoftWrapMode'

      * 'ToggleWrapMode'
    '';

    create_keymaps = defaultNullOpts.mkBool true ''
      If true, it will create the following normal-mode keymappings:

      * '[ow' (soft wrap mode)

      * ']ow' (hard wrap mode)

      * 'yow' (toggle wrap mode)
    '';

    auto_set_mode_filetype_allowlist = defaultNullOpts.mkListOf lib.types.str [
      "asciidoc"
      "gitcommit"
      "help"
      "latex"
      "mail"
      "markdown"
      "rst"
      "tex"
      "text"
      "typst"
    ] "Filetypes for automatic heuristic mode triggers.";

    auto_set_mode_filetype_denylist = defaultNullOpts.mkListOf lib.types.str [
    ] "Auto set mode filetype deny list";

    auto_set_mode_heuristically = defaultNullOpts.mkBool true ''
      If true, the plugin will set the hard or soft mode automatically when any file loads.

      For a specific set of file types, use `plugins.wrapping.settings.auto_set_mode_filetype_allowlist`.

      It uses the `BufWinEnter` event in an autocmd with a variety of undocumented heuristics.
      Refer to the [plugin documentation] for more details on this evolving behavior.

      [plugin documentation] https://github.com/andrewferrier/wrapping.nvim?tab=readme-ov-file#automatic-heuristic-mode'';

    set_nvim_opt_default = defaultNullOpts.mkBool true ''
      If true, wrapping.nvim will tweak some NeoVim defaults
      (linebreak and wrap) to make it operate more smoothly.
    '';
  };

  settingsExample = {
    notify_on_switch = false;
    create_commands = false;
    create_keymaps = false;
    auto_set_mode_filetype_allowlist = [
      "file"
      "filetwo"
    ];
  };
}
