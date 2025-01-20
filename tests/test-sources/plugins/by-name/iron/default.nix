{
  empty = {
    plugins.iron.enable = true;
  };

  defaults = {
    plugins.iron = {
      enable = true;

      settings = {
        scratch_repl = false;
        repl_definition = { };
        repl_open_cmd.__raw = ''
          require("iron.view").split.botright(40)
        '';
        highlight = { };
        highlight_last = "IronLastSent";
        ignore_blank_lines = true;
        should_map_plug = false;
        bufListed = false;
        keymaps = {
          send_motion = null;
          visual_send = null;
          send_file = null;
          send_paragraph = null;
          send_until_cursor = null;
          send_mark = null;
          mark_motion = null;
          remove_mark = null;
          cr = null;
          interrupt = null;
          exit = null;
          clear = null;
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
