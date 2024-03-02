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
        experimental = true;
        left_sep = ">";
        right_sep = "<";
        detect_modified = true;
        detect_paste = true;
        detect_crypt = true;
        detect_spell = true;
        detect_spelllang = true;
        detect_iminsert = false;
        inactive_collapse = true;
        inactive_alt_sep = true;
        theme = "dark";
        theme_patch_func = null;
        powerline_fonts = false;
        symbols_ascii = false;
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
        exclude_filenames = [];
        exclude_filetypes = [];
        filetype_overrides = {
          coc-explorer = ["CoC Explorer" ""];
          defx = ["defx" "%{b:defx.paths[0]}"];
          fugitive = ["fugitive" "%{airline#util#wrap(airline#extensions#branch#get_head(),80)}"];
          gundo = ["Gundo" ""];
          help = ["Help" "%f"];
          minibufexpl = ["MiniBufExplorer" ""];
          startify = ["startify" ""];
          vim-plug = ["Plugins" ""];
          vimfiler = ["vimfiler" "%{vimfiler#get_status_string()}"];
          vimshell = ["vimshell" "%{vimshell#get_status_string()}"];
          vaffle = ["Vaffle" "%{b:vaffle.dir}"];
        };
        exclude_preview = false;
        disable_statusline = false;
        skip_empty_sections = true;
        highlighting_cache = false;
        focuslost_inactive = false;
        statusline_ontop = false;
        stl_path_style = "short";
        section_c_only_filename = true;
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
