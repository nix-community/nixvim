{
  lib,
  helpers,
  config,
  ...
}:
with lib;
{
  options = {
    highlight = mkOption {
      type = types.attrsOf helpers.nixvimTypes.highlight;
      default = { };
      description = "Define new highlight groups";
      example = ''
        highlight = {
          MacchiatoRed.fg = "#ed8796";
        };
      '';
    };

    highlightOverride = mkOption {
      type = types.attrsOf helpers.nixvimTypes.highlight;
      default = { };
      description = "Define highlight groups to override existing highlight";
      example = ''
        highlightOverride = {
          Comment.fg = "#ff0000";
        };
      '';
    };

    match = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Define match groups";
      example = ''
        match = {
          ExtraWhitespace = "\\s\\+$";
        };
      '';
    };
  };

  config = {
    extraConfigLuaPre =
      (optionalString (config.highlight != { })
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
        ''
      )
      + (optionalString (config.match != { })
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
        ''
      );

    extraConfigLuaPost =
      optionalString (config.highlightOverride != { })
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
  };
}
