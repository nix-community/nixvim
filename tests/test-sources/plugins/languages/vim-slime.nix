{
  empty = {
    plugins.vim-slime.enable = true;
  };

  example = {
    plugins.vim-slime = {
      enable = true;

      settings = {
        target = "screen";
        vimterminal_cmd = null;
        no_mappings = false;
        paste_file = "$HOME/.slime_paste";
        preserve_curpos = true;
        default_config = {
          socket_name = "default";
          target_pane = "{last}";
        };
        dont_ask_default = false;
        bracketed_paste = false;
      };
    };
  };
}
