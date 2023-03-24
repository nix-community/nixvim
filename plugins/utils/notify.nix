{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.notify;
  helpers = import ../helpers.nix {inherit lib;};
  optionWarnings = import ../../lib/option-warnings.nix {inherit lib;};
  basePluginPath = ["plugins" "notify"];
  icon = mkOption {
    type = types.nullOr types.str;
    default = null;
  };
in {
  imports = [
    (optionWarnings.mkRenamedOption {
      # 2023-03-24
      option = basePluginPath ++ ["backgroundColor"];
      newOption = basePluginPath ++ ["backgroundColour"];
    })
  ];

  options.plugins.notify = {
    enable = mkEnableOption "notify";

    package = helpers.mkPackageOption "notify" pkgs.vimPlugins.nvim-notify;

    stages = mkOption {
      type = types.nullOr (types.enum ["fade_in_slide_out" "fade" "slide" "static"]);
      description = "Animation style";
      default = null;
    };
    timeout = mkOption {
      type = types.nullOr types.int;
      description = "Default timeout for notifications";
      default = null;
    };
    backgroundColour = mkOption {
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
      default = {};
    };
  };

  config = let
    setupOptions = with cfg; {
      stages = stages;
      timeout = timeout;
      background_colour = backgroundColour;
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
      extraPlugins = [cfg.package];
      extraConfigLua = ''
        vim.notify = require('notify');
        require('notify').setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
