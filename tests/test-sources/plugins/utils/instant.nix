{
  empty = {
    plugins.instant = {
      enable = true;
      username = null;
    };
  };

  example = {
    plugins.instant = {
      enable = true;

      settings = {
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
    };
  };
}
