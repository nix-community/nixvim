{
  empty = {
    plugins.airline.enable = true;
  };

  example = {
    plugins.airline = {
      enable = true;

      settings = {
        section_a = "foo";
        section_b = "foo";
        section_c = "foo";
        section_x = "foo";
        section_y = "foo";
        section_z = "foo";
        experimental = 1;
        left_sep = ">";
        right_sep = "<";
        detect_modified = 1;
        detect_paste = 1;
        detect_crypt = 1;
        detect_spell = 1;
        detect_spelllang = 1;
        detect_iminsert = 0;
        inactive_collapse = 1;
        inactive_alt_sep = 1;
        theme = "dark";
        theme_patch_func.__raw = "nil";
        powerline_fonts = 0;
        symbols_ascii = 0;
        mode_map = {
          __ = "-";
          c = "C";
          i = "I";
          ic = "I";
          ix = "I";
          n = "N";
          multi = "M";
          ni = "N";
          no = "N";
          R = "R";
          Rv = "R";
          s = "S";
          S = "S";
          t = "T";
          v = "V";
          V = "V";
        };
        exclude_filenames.__empty = { };
        exclude_filetypes.__empty = { };
        filetype_overrides = {
          coc-explorer = [
            "CoC Explorer"
            ""
          ];
          defx = [
            "defx"
            "%{b:defx.paths[0]}"
          ];
          fugitive = [
            "fugitive"
            "%{airline#util#wrap(airline#extensions#branch#get_head(),80)}"
          ];
          gundo = [
            "Gundo"
            ""
          ];
          help = [
            "Help"
            "%f"
          ];
          minibufexpl = [
            "MiniBufExplorer"
            ""
          ];
          startify = [
            "startify"
            ""
          ];
          vim-plug = [
            "Plugins"
            ""
          ];
          vimfiler = [
            "vimfiler"
            "%{vimfiler#get_status_string()}"
          ];
          vimshell = [
            "vimshell"
            "%{vimshell#get_status_string()}"
          ];
          vaffle = [
            "Vaffle"
            "%{b:vaffle.dir}"
          ];
        };
        exclude_preview = 0;
        disable_statusline = 0;
        skip_empty_sections = 1;
        highlighting_cache = 0;
        focuslost_inactive = 0;
        statusline_ontop = 0;
        stl_path_style = "short";
        section_c_only_filename = 1;
        symbols = {
          branch = "";
          colnr = " ℅:";
          readonly = "";
          linenr = " :";
          maxlinenr = "☰ ";
          dirty = "⚡";
        };
      };
    };
  };
}
