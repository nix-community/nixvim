{
  empty = {
    plugins.startify.enable = true;
  };

  example = {
    plugins.startify = {
      enable = true;

      settings = {
        session_dir = "~/.vim/session";
        lists = [
          {
            type = "files";
            header = [ "   MRU" ];
          }
          {
            type = "dir";
            header = [ { __raw = "'   MRU' .. vim.uv.cwd()"; } ];
          }
          {
            type = "sessions";
            header = [ "   Sessions" ];
          }
          {
            type = "bookmarks";
            header = [ "   Bookmarks" ];
          }
          {
            type = "commands";
            header = [ "   Commands" ];
          }
        ];
        commands = [
          ":help reference"
          [
            "Vim Reference"
            "h ref"
          ]
          { h = "h ref"; }
          {
            m = [
              "My magical function"
              "call Magic()"
            ];
          }
        ];
        files_number = 10;
        update_oldfiles = false;
        session_autoload = false;
        session_before_save = [ "silent! tabdo NERDTreeClose" ];
        session_persistence = false;
        session_delete_buffers = true;
        change_to_dir = true;
        change_to_vcs_root = false;
        change_cmd = "lcd";
        skiplist = [
          "\\.vimgolf"
          "^/tmp"
          "/project/.*/documentation"
        ];
        fortune_use_unicode = false;
        padding_left = 3;
        skiplist_server = [ "GVIM" ];
        enable_special = true;
        enable_unsafe = false;
        session_remove_lines = [
          "setlocal"
          "winheight"
        ];
        session_savevars = [
          "g:startify_session_savevars"
          "g:startify_session_savecmds"
          "g:random_plugin_use_feature"
        ];
        session_savecmds = [ "silent !pdfreader ~/latexproject/main.pdf &" ];
        session_number = 999;
        session_sort = false;
        custom_indices = [
          "f"
          "g"
          "h"
        ];
        custom_header = [
          ""
          "     ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
          "     ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
          "     ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
          "     ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
          "     ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
          "     ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
        ];
        custom_header_quotes = [
          [ "quote #1" ]
          [
            "quote #2"
            "using"
            "three lines"
          ]
        ];
        custom_footer.__raw = "nil";
        disable_at_vimenter = false;
        relative_path = false;
        use_env = false;
      };
    };
  };
}
