{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.plugins.notify;
  helpers = import ../helpers.nix { lib = lib; };
  icon = mkOption {
    type = types.nullOr types.str;
    default = null;
  };
in
{
  options.plugins.notify = {
    enable = mkEnableOption "Enable notify";

    stages = mkOption {
      type = types.nullOr (types.enum [ "fade_in_slide_out" "fade" "slide" "static" ]);
      description = "Animation style";
      default = null;
    };
    timeout = mkOption {
      type = types.nullOr types.int;
      description = "Default timeout for notifications";
      default = null;
    };
    backgroundColor = mkOption {
      type = types.nullOr types.str;
      description = "For stages that change opacity this is treated as the highlight between the window";
      default = null;
    };
    minimumWidth = mkOption {
      type = types.nullOr types.int;
      description = "Minimum width for notification windows";
      default = null;
    };
    icons = mkOption {
      type = types.nullOr (types.submodule {
        options = {
          error = icon;
          warn = icon;
          info = icon;
          debug = icon;
          trace = icon;
        };
      });
      description = "Icons for the different levels";
      default = { };
    };
  };

  config =
    let
      setupOptions = with cfg; {
        stages = stages;
        timeout = timeout;
        background_color = backgroundColor;
        minimum_width = minimumWidth;
        icons = with icons; {
          ERROR = error;
          WARN = warn;
          INFO = info;
          DEBUG = debug;
          TRACE = trace;
        };
      };
    in
    mkIf cfg.enable {
      extraPlugins = [ pkgs.vimPlugins.nvim-notify ];
      extraConfigLua = ''
        vim.notify = require('notify');
        require('notify').setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
