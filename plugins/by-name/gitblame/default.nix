{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "gitblame";
  originalName = "git-blame.nvim";
  package = "git-blame-nvim";

  maintainers = with lib.maintainers; [ GaetanLepage ];

  # TODO: introduce 2024-08-03. Remove after 24.11
  optionsRenamedToSettings = [
    "messageTemplate"
    "dateFormat"
    "messageWhenNotCommitted"
    "highlightGroup"
    "extmarkOptions"
    "displayVirtualText"
    "ignoredFiletypes"
    "delay"
    "virtualTextColumn"
  ];

  settingsOptions = {
    enabled = defaultNullOpts.mkBool true ''
      Enables the plugin on Neovim startup.
      You can toggle git blame messages on/off with the `:GitBlameToggle` command.
    '';

    message_template = defaultNullOpts.mkStr "  <author> • <date> • <summary>" ''
      The template for the blame message that will be shown.

      Available options: `<author>`, `<committer>`, `<date>`, `<committer-date>`, `<summary>`,
      `<sha>`.
    '';

    date_format = defaultNullOpts.mkStr "%c" ''
      The [format](https://www.lua.org/pil/22.1.html) of the date fields in `message_template`.

      See [upstream doc](https://github.com/f-person/git-blame.nvim?tab=readme-ov-file#date-format)
      for the available options.
    '';

    message_when_not_committed = defaultNullOpts.mkStr "  Not Committed Yet" ''
      The blame message that will be shown when the current modification hasn't been committed yet.

      Supports the same template options as `message_template`.
    '';

    highlight_group = defaultNullOpts.mkStr "Comment" ''
      The highlight group for virtual text.
    '';

    set_extmark_options = defaultNullOpts.mkAttrsOf types.anything { } ''
      `nvim_buf_set_extmark` is the function used for setting the virtual text.
      You can view an up-to-date full list of options in the
      [Neovim documentation](https://neovim.io/doc/user/api.html#nvim_buf_set_extmark()).

      **Warning:** overwriting `id` and `virt_text` will break the plugin behavior.
    '';

    display_virtual_text = defaultNullOpts.mkBool true ''
      If the blame message should be displayed as virtual text.
      You may want to disable this if you display the blame message in statusline.
    '';

    ignored_filetypes = defaultNullOpts.mkListOf types.str [ ] ''
      A list of filetypes for which gitblame information will not be displayed.
    '';

    delay = defaultNullOpts.mkUnsignedInt 250 ''
      The delay in milliseconds after which the blame info will be displayed.
    '';

    virtual_text_column = defaultNullOpts.mkUnsignedInt null ''
      Have the blame message start at a given column instead of EOL.
      If the current line is longer than the specified column value, the blame message will default
      to being displayed at EOL.
    '';

    use_blame_commit_file_urls = defaultNullOpts.mkBool false ''
      By default the commands `GitBlameOpenFileURL` and `GitBlameCopyFileURL` open the current file
      at latest branch commit.
      If you would like to open these files at the latest blame commit (in other words, the commit
      marked by the blame), set this to true.
      For ranges, the blame selected will be the most recent blame from the range.
    '';

    schedule_event = defaultNullOpts.mkStr "CursorMoved" ''
      If you are experiencing poor performance (e.g. in particularly large projects) you can use
      `CursorHold` instead of the default `CursorMoved` autocommand to limit the frequency of events
      being run.
    '';

    clear_event = defaultNullOpts.mkStr "CursorMovedI" ''
      If you are experiencing poor performance (e.g. in particularly large projects) you can use
      `CursorHoldI` instead of the default `CursorMovedI` autocommand to limit the frequency of
      events being run.
    '';

    clipboard_register = defaultNullOpts.mkStr "+" ''
      By default the `:GitBlameCopySHA`, `:GitBlameCopyFileURL` and `:GitBlameCopyCommitURL`
      commands use the `+` register.
      Set this value if you would like to use a different register (such as `*`).
    '';
  };

  settingsExample = {
    message_template = "<summary> • <date> • <author>";
    date_format = "%r";
    message_when_not_committed = "Oh please, commit this !";
    highlight_group = "Question";
    set_extmark_options.priority = 7;
    display_virtual_text = false;
    ignored_filetypes = [
      "lua"
      "c"
    ];
    delay = 1000;
    virtual_text_column = 80;
    use_blame_commit_file_urls = true;
  };

  extraOptions = {
    gitPackage = lib.mkPackageOption pkgs "git" {
      nullable = true;
    };
  };

  extraConfig = cfg: { extraPackages = [ cfg.gitPackage ]; };
}
