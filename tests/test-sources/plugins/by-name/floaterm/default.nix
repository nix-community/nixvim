{
  empty = {
    plugins.floaterm.enable = true;
  };

  defaults = {
    plugins.floaterm = {
      enable = true;

      settings = {
        shell = null;
        title = "floaterm: $1/$2";
        wintype = "float";
        width = 0.6;
        height = 0.6;
        position = "center";
        borderchars = "─│─│┌┐┘└";
        rootmarkers = [
          ".project"
          ".git"
          ".hg"
          ".svn"
          ".root"
        ];
        opener = "split";
        autoclose = 1;
        autohide = 1;
        autoinsert = true;
        titleposition = "left";
        giteditor = true;
        keymap_new = "";
        keymap_prev = "";
        keymap_next = "";
        keymap_first = "";
        keymap_last = "";
        keymap_hide = "";
        keymap_show = "";
        keymap_kill = "";
        keymap_toggle = "";
      };
    };
  };

  example = {
    plugins.floaterm = {
      enable = true;

      settings = {
        width = 0.9;
        height = 0.9;
        opener = "edit ";
        title = "";
        rootmarkers = [
          "build/CMakeFiles"
          ".project"
          ".git"
          ".hg"
          ".svn"
          ".root"
        ];
        keymap_new = "<Leader>ft";
        keymap_prev = "<Leader>fp";
        keymap_next = "<Leader>fn";
        keymap_toggle = "<Leader>t";
        keymap_kill = "<Leader>fk";
      };
    };
  };
}
