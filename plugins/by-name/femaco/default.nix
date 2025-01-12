{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "femaco";
  packPathName = "nvim-FeMaco.lua";
  package = "nvim-FeMaco-lua";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    prepare_buffer =
      defaultNullOpts.mkRaw
        ''
          function(opts)
            local buf = vim.api.nvim_create_buf(false, false)
            return vim.api.nvim_open_win(buf, true, opts)
          end
        ''
        ''
          This function should prepare a new buffer and return the `winid`.
          By default, it opens a floating window.
          Provide a different callback to change this behaviour.

          ```lua
          @param opts: the return value from float_opts
          ```
        '';

    float_opts =
      defaultNullOpts.mkRaw
        ''
          function(code_block)
            return {
              relative = 'cursor',
              width = require('femaco.utils').clip_val(5, 120, vim.api.nvim_win_get_width(0) - 10),
              height = require('femaco.utils').clip_val(5, #code_block.lines, vim.api.nvim_win_get_height(0) - 6),
              anchor = 'NW',
              row = 0,
              col = 0,
              style = 'minimal',
              border = 'rounded',
              zindex = 1,
            }
          end
        ''
        ''
          Should return options passed to `nvim_open_win`
          `@param code_block`: data about the code-block with the keys
          - `range`
          - `lines`
          - `lang`
        '';

    ft_from_lang =
      defaultNullOpts.mkRaw
        ''
          function(lang)
            return lang
          end
        ''
        ''
          Return filetype to use for a given lang.
          `lang` can be `nil`.
        '';

    post_open_float =
      defaultNullOpts.mkRaw
        ''
          function(winnr)
            vim.wo.signcolumn = 'no'
          end
        ''
        ''
          What to do after opening the float.
        '';

    create_tmp_filepath =
      defaultNullOpts.mkRaw
        ''
          function(filetype)
            return os.tmpname()
          end
        ''
        ''
          Create the path to a temporary file.
        '';

    ensure_newline =
      defaultNullOpts.mkRaw
        ''
          function(base_filetype)
            return false
          end
        ''
        ''
          Whether a newline should always be used.
          This is useful for multiline injections which separators needs to be on separate lines
          such as markdown, neorg etc.

          `@param base_filetype`: The filetype which FeMaco is called from, not the filetype of the
          injected language (this is the current buffer so you can get it from `vim.bo.filetyp`).
        '';

    normalize_indent =
      defaultNullOpts.mkRaw
        ''
          function (base_filetype)
            return false
          end
        ''
        ''
          Should return `true` if the indentation should be normalized.

          Useful when the injected language inherits indentation from the construction scope (e.g.
          an inline multiline sql string).

          If `true`, the leading indentation is detected, stripped, and restored before/after
          editing.

          `@param base_filetype`: The filetype which FeMaco is called from, not the filetype of the
          injected language (this is the current buffer, so you can get it from `vim.bo.filetype`).
        '';
  };

  settingsExample = {
    ft_from_lang.__raw = ''
      function(lang)
        if mapped_filetype[lang] then
          return mapped_filetype[lang]
        end
        return lang
      end
    '';
    ensure_newline.__raw = ''
      function(base_filetype)
        return true
      end
    '';
  };
}
