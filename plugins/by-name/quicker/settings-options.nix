lib:
let
  inherit (lib) types mkOption;
  inherit (lib.nixvim) defaultNullOpts literalLua;
in
{
  opts =
    defaultNullOpts.mkAttrsOf types.anything
      {
        buflisted = false;
        number = false;
        relativenumber = false;
        signcolumn = "auto";
        winfixheight = true;
        wrap = false;
      }
      ''
        Local options to set for quickfix.
      '';

  use_default_opts = defaultNullOpts.mkBool true ''
    Set to `false` to disable the default options in `opts`.
  '';

  keys =
    defaultNullOpts.mkListOf
      (types.submodule {
        freeformType = with types; attrsOf anything;

        options = {
          __unkeyed-1 = mkOption {
            type = with types; maybeRaw str;
            example = ">";
            description = ''
              Key sequence.
            '';
          };

          __unkeyed-2 = mkOption {
            type = with types; maybeRaw str;
            example = literalLua "require('quicker').collapse";
            description = ''
              Command to run.
            '';
          };
          # Options forwarded to `vim.keymap.set`
          # https://github.com/stevearc/quicker.nvim/blob/master/lua/quicker/keys.lua
          inherit (lib.nixvim.keymaps.mapConfigOptions)
            desc
            nowait
            remap
            silent
            ;
        };
      })
      [
        {
          __unkeyed-1 = ">";
          __unkeyed-2 = "<cmd>lua require('quicker').toggle_expand()<CR>";
          desc = "Expand quickfix content";
        }
      ]
      ''
        Keymaps to set for the quickfix buffer.
      '';

  on_qf = defaultNullOpts.mkRaw "function(bufnr) end" ''
    Callback function to run any custom logic or keymaps for the quickfix buffer.
  '';

  edit = {
    enabled = defaultNullOpts.mkBool true ''
      Enable editing the quickfix like a normal buffer.
    '';

    autosave = defaultNullOpts.mkNullable' {
      type = with types; either bool (enum [ "autosave" ]);
      pluginDefault = "autosave";
      example = true;
      description = ''
        - Set to `true` to write buffers after applying edits.
        - Set to `"unmodified"` to only write unmodified buffers.
      '';
    };
  };

  constrain_cursor = defaultNullOpts.mkBool true ''
    Keep the cursor to the right of the filename and lnum columns.
  '';

  highlight = {
    treesitter = defaultNullOpts.mkBool true ''
      Use treesitter highlighting.
    '';

    lsp = defaultNullOpts.mkBool true ''
      Use LSP semantic token highlighting.
    '';

    load_buffers = defaultNullOpts.mkBool false ''
      Load the referenced buffers to apply more accurate highlights (may be slow).
    '';
  };

  follow = {
    enabled = defaultNullOpts.mkBool false ''
      When quickfix window is open, scroll to closest item to the cursor.
    '';
  };

  type_icons =
    defaultNullOpts.mkAttrsOf types.str
      {
        E = "󰅚 ";
        W = "󰀪 ";
        I = " ";
        N = " ";
        H = " ";
      }
      ''
        Map of quickfix item type to icon.
      '';

  borders =
    defaultNullOpts.mkAttrsOf types.str
      {
        vert = "┃";
        strong_header = "━";
        strong_cross = "╋";
        strong_end = "┫";
        soft_header = "╌";
        soft_cross = "╂";
        soft_end = "┨";
      }
      ''
        Border characters.
      '';

  trim_leading_whitespace = defaultNullOpts.mkEnum [ "all" "common" false ] "common" ''
    How to trim the leading whitespace from results.
  '';

  max_filename_width =
    defaultNullOpts.mkUnsignedInt
      (literalLua ''
        function()
          return math.floor(math.min(95, vim.o.columns / 2))
        end
      '')
      ''
        Maximum width of the filename column.
      '';

  header_length =
    defaultNullOpts.mkUnsignedInt
      (literalLua ''
        function(type, start_col)
          return vim.o.columns - start_col
        end
      '')
      ''
        How far the header should extend to the right.
      '';
}
