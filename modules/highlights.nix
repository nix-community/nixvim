{ config, lib, ... }:
let
  helpers = import ../plugins/helpers.nix { inherit config lib; };
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
  };

  config = mkIf (config.highlight != { }) {
    extraConfigLuaPost = ''
      -- Highlight groups {{
      do
        local highlights = ${helpers.toLuaObject config.highlight}

        for k,v in pairs(highlights) do
          vim.api.nvim_set_hl(0, k, v)
        end
      end
      -- }}
    '';
  };
}
