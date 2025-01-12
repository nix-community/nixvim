{
  empty = {
    plugins.femaco.enable = true;
  };

  defaults = {
    plugins.femaco = {
      enable = true;

      settings = {
        prepare_buffer.__raw = ''
          function(opts)
            local buf = vim.api.nvim_create_buf(false, false)
            return vim.api.nvim_open_win(buf, true, opts)
          end
        '';
        float_opts.__raw = ''
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
        '';
        ft_from_lang.__raw = ''
          function(lang)
            return lang
          end
        '';
        post_open_float.__raw = ''
          function(winnr)
            vim.wo.signcolumn = 'no'
          end
        '';
        create_tmp_filepath.__raw = ''
          function(filetype)
            return os.tmpname()
          end
        '';
        ensure_newline.__raw = ''
          function(base_filetype)
            return false
          end
        '';
        normalize_indent.__raw = ''
          function (base_filetype)
            return false
          end
        '';
      };
    };
  };

  example = {
    plugins.femaco = {
      enable = true;

      settings = {
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
    };
  };
}
