{
  lib,
  helpers,
  config,
  ...
}:
{
  options = {
    highlight = lib.mkOption {
      type = lib.types.attrsOf lib.types.highlight;
      default = { };
      description = "Define new highlight groups";
      example = {
        MacchiatoRed.fg = "#ed8796";
      };
    };

    highlightOverride = lib.mkOption {
      type = lib.types.attrsOf lib.types.highlight;
      default = { };
      description = "Define highlight groups to override existing highlight";
      example = {
        Comment.fg = "#ff0000";
      };
    };

    match = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Define match groups";
      example = {
        ExtraWhitespace = "\\s\\+$";
      };
    };
  };

  config = lib.mkMerge [
    {
      extraConfigLuaPre =
        lib.mkIf (config.highlight != { })
          # lua
          ''
            -- Highlight groups {{
            do
              local highlights = ${helpers.toLuaObject config.highlight}

              for k,v in pairs(highlights) do
                vim.api.nvim_set_hl(0, k, v)
              end
            end
            -- }}
          '';
      extraConfigLuaPost =
        lib.mkIf (config.highlightOverride != { })
          # lua
          ''
            -- Highlight groups {{
            do
              local highlights = ${helpers.toLuaObject config.highlightOverride}

              for k,v in pairs(highlights) do
                vim.api.nvim_set_hl(0, k, v)
              end
            end
            -- }}
          '';
    }
    {
      extraConfigLuaPre =
        lib.mkIf (config.match != { })
          # lua
          ''
            -- Match groups {{
            do
              local match = ${helpers.toLuaObject config.match}

              for k,v in pairs(match) do
                vim.fn.matchadd(k, v)
              end
            end
              -- }}
          '';
    }
  ];
}
