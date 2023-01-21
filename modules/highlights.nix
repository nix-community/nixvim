{ config, lib, ... }:
let
  helpers = import ../plugins/helpers.nix { inherit lib; };
in
with lib;
{
  options = {
    highlight = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Define highlight groups";
      example = ''
        highlight = {
          Comment.fg = '#ff0000';
        };
      '';
    };

    match = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Define match groups";
      example = ''
        match = {
          ExtraWhitespace = '\\s\\+$';
        };
      '';
    };
  };

  config = mkIf (config.highlight != { } || config.match != { }) {
    extraConfigLuaPost = (optionalString (config.highlight != { }) ''
      -- Highlight groups {{
      do
        local highlights = ${helpers.toLuaObject config.highlight}

        for k,v in pairs(highlights) do
          vim.api.nvim_set_hl(0, k, v)
        end
      end
      -- }}
    '') ++
    (optionalString (config.match != { }) ''
      -- Match groups {{
        do
          local match = ${helpers.toLuaObject config.match}

          for k,v in pairs(match) do
            vim.fn.matchadd(k, v)
          end
        end
        -- }}
    '');
  };
}

