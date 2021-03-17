{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.nvim-autopairs;
  helpers = import ../helpers.nix { lib = lib; };
in
{
  options.programs.nixvim.plugins.nvim-autopairs = {
    enable = mkEnableOption "Enable nvim-autopairs";

    pairs = mkOption {
      type = types.nullOr (types.attrsOf types.str);
      default = null;
      description = "Characters to pair up";
    };

    disabledFiletypes = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = "Disabled filetypes";
    };

    breakLineFiletypes = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = "Filetypes to break lines on";
    };

    htmlFiletypes = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = "Filetypes to treat as HTML";
    };

    ignoredNextChar = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Regexp to ignore if it matches the next character";
    };
  };

  config = let
    options = {
      pairs_map = cfg.pairs;
      disable_filetype = cfg.disabledFiletypes;
      break_line_filetype = cfg.breakLineFiletypes;
      html_break_line_filetype = cfg.htmlFiletypes;
      ignored_next_char = cfg.ignoredNextChar;
    };
  in mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [ pkgs.vimPlugins.nvim-autopairs ];

      extraConfigLua = ''
        require('nvim-autopairs').setup(${helpers.toLuaObject options})
      '';
    };
  };
}
