{
  lib,
  helpers,
  ...
}:
with lib;
with lib.nixvim.vim-plugin;
mkVimPlugin {
  name = "instant";
  packPathName = "instant.nvim";
  package = "instant-nvim";
  globalPrefix = "instant_";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-03-02: remove 2024-05-02
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [
    "username"
    "onlyCwd"
    "cursorHlGroupUser1"
    "cursorHlGroupUser2"
    "cursorHlGroupUser3"
    "cursorHlGroupUser4"
    "cursorHlGroupDefault"
    "nameHlGroupUser1"
    "nameHlGroupUser2"
    "nameHlGroupUser3"
    "nameHlGroupUser4"
    "nameHlGroupDefault"
  ];

  settingsOptions = {
    username = helpers.mkNullOrStr ''
      Username.
      Explicitly set to `null` if you do not want this option to be set.
    '';

    only_cwd = helpers.defaultNullOpts.mkBool true ''
      Choose whether to share files only in the current working directory in session mode.
    '';

    cursor_hl_group_user1 = helpers.defaultNullOpts.mkStr "Cursor" ''
      Cursor highlight group for user 1.
    '';

    cursor_hl_group_user2 = helpers.defaultNullOpts.mkStr "Cursor" ''
      Cursor highlight group for user 2.
    '';

    cursor_hl_group_user3 = helpers.defaultNullOpts.mkStr "Cursor" ''
      Cursor highlight group for user 3.
    '';

    cursor_hl_group_user4 = helpers.defaultNullOpts.mkStr "Cursor" ''
      Cursor highlight group for user 4.
    '';

    cursor_hl_group_default = helpers.defaultNullOpts.mkStr "Cursor" ''
      Cursor highlight group for any other userr.
    '';

    name_hl_group_user1 = helpers.defaultNullOpts.mkStr "CursorLineNr" ''
      Virtual text highlight group for user 1.
    '';

    name_hl_group_user2 = helpers.defaultNullOpts.mkStr "CursorLineNr" ''
      Virtual text highlight group for user 2.
    '';

    name_hl_group_user3 = helpers.defaultNullOpts.mkStr "CursorLineNr" ''
      Virtual text highlight group for user 3.
    '';

    name_hl_group_user4 = helpers.defaultNullOpts.mkStr "CursorLineNr" ''
      Virtual text highlight group for user 4.
    '';

    name_hl_group_default = helpers.defaultNullOpts.mkStr "CursorLineNr" ''
      Virtual text highlight group for any other user.
    '';
  };

  settingsExample = {
    username = "Joe";
    onlyCwd = true;
    cursor_hl_group_user1 = "Cursor";
    cursor_hl_group_user2 = "Cursor";
    cursor_hl_group_user3 = "Cursor";
    cursor_hl_group_user4 = "Cursor";
    cursor_hl_group_default = "Cursor";
    name_hl_group_user1 = "CursorLineNr";
    name_hl_group_user2 = "CursorLineNr";
    name_hl_group_user3 = "CursorLineNr";
    name_hl_group_user4 = "CursorLineNr";
    name_hl_group_default = "CursorLineNr";
  };
}
