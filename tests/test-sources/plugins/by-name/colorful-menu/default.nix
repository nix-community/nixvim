{
  empty = {
    plugins.colorful-menu.enable = true;
  };

  defaults = {
    plugins.colorful-menu = {
      enable = true;

      settings = {
        ls = {
          lua_ls = {
            arguments_hl = "@comment";
          };
          gopls = {
            add_colon_before_type = false;
            align_type_to_right = true;
            preserve_type_when_truncate = true;
          };
          ts_ls = {
            extra_info_hl = "@comment";
          };
          vtsls = {
            extra_info_hl = "@comment";
          };
          zls = {
            align_type_to_right = true;
          };
          rust-analyzer = {
            extra_info_hl = "@comment";
            align_type_to_right = true;
            preserve_type_when_truncate = true;
          };
          clangd = {
            extra_info_hl = "@comment";
            import_dot_hl = "@comment";
            align_type_to_right = true;
            preserve_type_when_truncate = true;
          };
          roslyn = {
            extra_info_hl = "@comment";
          };
          basedpyright = {
            extra_info_hl = "@comment";
          };
          dartls = {
            extra_info_hl = "@comment";
          };
          fallback = true;
          fallback_extra_info_hl = "@comment";
        };
        fallback_highlight = "@variable";
        max_width = 60;
      };
    };
  };

  withCmp = {
    plugins = {
      colorful-menu.enable = true;

      cmp = {
        enable = true;
        settings.formatting.format.__raw = ''
          function(entry, vim_item)
            local highlights_info = require("colorful-menu").cmp_highlights(entry)

            -- highlight_info is nil means we are missing the ts parser, it's
            -- better to fallback to use default `vim_item.abbr`. What this plugin
            -- offers is two fields: `vim_item.abbr_hl_group` and `vim_item.abbr`.
            if highlights_info ~= nil then
                vim_item.abbr_hl_group = highlights_info.highlights
                vim_item.abbr = highlights_info.text
            end

            return vim_item
          end
        '';
      };
    };
  };

  example = {
    plugins.colorful-menu = {
      enable = true;

      settings = {
        ls = {
          lua_ls.arguments_hl = "@comment";
          pyright.extra_info_hl = "@comment";
          fallback = true;
        };
        fallback_highlight = "@variable";
        max_width = 60;
      };
    };
  };
}
