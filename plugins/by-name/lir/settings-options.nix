lib:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
{
  show_hidden_files = defaultNullOpts.mkBool false ''
    Whether to show files whose file names start with `.` by default.
  '';

  ignore = defaultNullOpts.mkListOf' {
    pluginDefault = [ ];
    example = [
      ".DS_Store"
      "node_modules"
    ];
    description = ''
      List of files not to be displayed.
    '';
  };

  devicons = {
    enable = defaultNullOpts.mkBool false ''
      Whether to show devicons.
      This requires enabling `plugins.web-devicons`.
    '';

    highlight_dirname = defaultNullOpts.mkBool false ''
      Whether to highlight dirnames with devicons enabled.
    '';
  };

  mappings = defaultNullOpts.mkAttrsOf' {
    type = types.rawLua;
    pluginDefault = { };
    example = {
      l.__raw = "require('lir').actions.edit";
      "<C-s>".__raw = "require'lir.actions'.split";
      "<C-v>".__raw = "require'lir.actions'.vsplit";
      "<C-t>".__raw = "require'lir.actions'.tabedit";
      J.__raw = ''
        function()
          mark_actions.toggle_mark()
          vim.cmd('normal! j')
        end
      '';
    };
    description = ''
      Specify the table to be used for mapping.
      You can also specify a function that you define yourself.
    '';
  };

  hide_cursor = defaultNullOpts.mkBool false ''
    Whether to hide the cursor in lir?

    If the cursor is shown, it will be prefixed with a space.
  '';

  get_filters = defaultNullOpts.mkRaw null ''
    `|lir-file-item|` function that returns a list of functions to filter for.

    They are called in order from the top of the list before being displayed on the buffer.

    Set up a function that returns a list of the following functions.
    `lir_item` is `|lir-file-item|`.

    Signature:
    ```lua
    fun(files: lir_item[]): lir_item[]
    ```
  '';

  float = {
    winblend = defaultNullOpts.mkUnsignedInt 0 ''
      The degree of transparency of the window displayed by the floating window.
    '';

    win_opts = defaultNullOpts.mkAttrsOf' {
      type = types.str;
      pluginDefault = {
        relative = "editor";
        row.__raw = "math.floor((vim.o.lines - (vim.o.lines * 0.5)) / 2) - 1";
        col.__raw = "math.floor((vim.o.lines - (vim.o.columns * 0.5)) / 2)";
        width.__raw = "math.floor(vim.o.columns * 0.5)";
        height.__raw = "math.floor(vim.o.lines * 0.5)";
        style = "minimal";
        border = "double";
      };
      example.__raw = ''
        function()
          local width = math.floor(vim.o.columns * 0.6)
          local height = math.floor(vim.o.lines * 0.8)
          return {
            border = require("lir.float.helper").make_border_opts({
              "+", "─", "+", "│", "+", "─", "+", "│",
            }, "Normal"),
            width = width,
            height = height,
            row = 10,
            col = math.floor((vim.o.columns - width) / 2),
          }
        end
      '';
      description = ''
        Specifies the function that returns the table to be passed as the third argument of
        `|nvim_open_win()|`.

        Use this when you want to override the default configs.
      '';
    };

    curdir_window = {
      enable = defaultNullOpts.mkBool false ''
        Whether to show current directory window.
      '';

      highlight_dirname = defaultNullOpts.mkBool false ''
        Whether to highlight a directory in the current directory window in a floating window?
      '';
    };
  };
}
