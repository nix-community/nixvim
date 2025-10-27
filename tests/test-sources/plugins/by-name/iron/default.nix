{
  empty = {
    plugins.iron.enable = true;
  };

  defaults = {
    plugins.iron = {
      enable = true;

      settings = {
        scratch_repl = false;
        repl_definition.__empty = { };
        repl_open_cmd.__raw = ''
          require("iron.view").split.botright(40)
        '';
        highlight.__empty = { };
        highlight_last = "IronLastSent";
        ignore_blank_lines = true;
        should_map_plug = false;
        bufListed = false;
        keymaps = {
          send_motion.__raw = "nil";
          visual_send.__raw = "nil";
          send_file.__raw = "nil";
          send_paragraph.__raw = "nil";
          send_until_cursor.__raw = "nil";
          send_mark.__raw = "nil";
          mark_motion.__raw = "nil";
          remove_mark.__raw = "nil";
          cr.__raw = "nil";
          interrupt.__raw = "nil";
          exit.__raw = "nil";
          clear.__raw = "nil";
        };
      };
    };
  };

  example = {
    plugins.iron = {
      enable = true;

      settings = {
        scratch_repl = true;
        repl_definition = {
          sh = {
            command = [ "zsh" ];
          };
          python = {
            command = [ "python3" ];
            format.__raw = "require('iron.fts.common').bracketed_paste_python";
          };
        };
        repl_open_cmd.__raw = ''require("iron.view").bottom(40)'';
        keymaps = {
          send_motion = "<space>sc";
          visual_send = "<space>sc";
          send_line = "<space>sl";
        };
        highlight = {
          italic = true;
        };
      };
    };
  };
}
