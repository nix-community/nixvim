{
  empty = {
    plugins.vim-slime.enable = true;
  };

  example = {
    plugins.vim-slime = {
      enable = true;

      settings = {
        target = "screen";
        vimterminal_cmd.__raw = "nil";
        no_mappings = 0;
        paste_file = "$HOME/.slime_paste";
        preserve_curpos = 1;
        default_config = {
          socket_name = "default";
          target_pane = "{last}";
        };
        dont_ask_default = 0;
        bracketed_paste = 0;
      };
    };
  };
}
