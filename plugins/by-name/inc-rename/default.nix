{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "inc-rename";
  moduleName = "inc_rename";
  package = "inc-rename-nvim";
  description = ''
    A small Neovim plugin that provides a command for LSP renaming with
    immediate visual feedback thanks to Neovim's command preview feature.
  '';

  maintainers = [ lib.maintainers.jolars ];

  # TODO: introduced 2025-01-08: remove after 25.05
  optionsRenamedToSettings = [
    "cmdName"
    "hlGroup"
    "previewEmptyName"
    "showMessage"
    "inputBufferType"
    "postHook"
  ];

  settingsOptions = {
    cmd_name = defaultNullOpts.mkStr "IncRename" "The name of the command.";

    hl_group = defaultNullOpts.mkStr "Substitute" ''
      The highlight group used for highlighting the identifier's new name.
    '';

    preview_empty_name = defaultNullOpts.mkBool false ''
      Whether an empty new name should be previewed; if false the command
      preview will be cancelled instead.
    '';

    show_message = defaultNullOpts.mkBool true ''
      Whether to display a `Renamed m instances in n files` message after a rename operation.
    '';

    save_in_cmdline_history = defaultNullOpts.mkBool true ''
      Whether to save the `IncRename` command in the commandline history. Set to
      false to prevent issues with navigating to older entries that may arise due to
      the behavior of command preview).
    '';

    input_buffer_type = defaultNullOpts.mkNullable (types.enum [ "dressing" ]) null ''
      The type of the external input buffer to use.
    '';

    post_hook = defaultNullOpts.mkRaw null ''
      Callback to run after renaming, receives the result table (from LSP
      handler) as an argument.
    '';
  };

  settingsExample = {
    input_buffer_type = "dressing";
    preview_empty_name = false;
    show_message.__raw = ''
      function(msg)
        vim.notify(msg, vim.log.levels.INFO, { title = "Rename" })
      end
    '';
  };
}
