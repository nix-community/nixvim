{
  empty = {
    plugins.gitblame.enable = true;
  };

  defaults = {
    plugins.gitblame = {
      enable = true;

      settings = {
        enabled = true;
        message_template = "  <author> • <date> • <summary>";
        date_format = "%c";
        message_when_not_committed = "  Not Committed Yet";
        highlight_group = "Comment";
        set_extmark_options.__empty = { };
        display_virtual_text = true;
        ignored_filetypes.__empty = { };
        delay = 250;
        virtual_text_column.__raw = "nil";
        use_blame_commit_file_urls = false;
        schedule_event = "CursorMoved";
        clear_event = "CursorMovedI";
        clipboard_register = "+";
      };
    };
  };

  example = {
    plugins.gitblame = {
      enable = true;

      settings = {
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
        schedule_event = "CursorHold";
        clear_event = "CursorHoldI";
        clipboard_register = "*";
      };
    };
  };
}
