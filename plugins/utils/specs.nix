{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.specs;
in {
  options.plugins.specs = {
    enable = mkEnableOption "specs-nvim";

    package = helpers.mkPluginPackageOption "specs-nvim" pkgs.vimPlugins.specs-nvim;

    show_jumps = mkOption {
      type = types.bool;
      default = true;
    };

    min_jump = mkOption {
      type = types.int;
      default = 30;
    };

    delay = mkOption {
      type = types.int;
      default = 0;
      description = "Delay in milliseconds";
    };

    increment = mkOption {
      type = types.int;
      default = 10;
      description = "Increment in milliseconds";
    };

    blend = mkOption {
      type = types.int;
      default = 10;
    };

    color = mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    width = mkOption {
      type = types.int;
      default = 10;
    };

    fader = mkOption {
      type = types.submodule {
        options = {
          builtin = mkOption {
            type = types.nullOr (
              types.enum [
                "linear_fader"
                "exp_fader"
                "pulse_fader"
                "empty_fader"
              ]
            );
            default = "linear_fader";
          };

          custom = mkOption {
            type = types.lines;
            default = "";
            example = ''
              function(blend, cnt)
                if cnt > 100 then
                    return 80
                else return nil end
              end
            '';
          };
        };
      };
      default = {
        builtin = "linear_fader";
      };
    };

    resizer = mkOption {
      type = types.submodule {
        options = {
          builtin = mkOption {
            type = types.nullOr (
              types.enum [
                "shrink_resizer"
                "slide_resizer"
                "empty_resizer"
              ]
            );
            default = "shrink_resizer";
          };

          custom = mkOption {
            type = types.lines;
            default = "";
            example = ''
              function(width, ccol, cnt)
                  if width-cnt > 0 then
                      return {width+cnt, ccol}
                  else return nil end
              end
            '';
          };
        };
      };
      default = {
        builtin = "shrink_resizer";
      };
    };

    ignored_filetypes = mkOption {
      type = with types; listOf str;
      default = [];
    };

    ignored_buffertypes = mkOption {
      type = with types; listOf str;
      default = ["nofile"];
    };
  };
  config = let
    setup = helpers.toLuaObject {
      inherit (cfg) show_jumps min_jump;
      ignore_filetypes = attrsets.listToAttrs (
        lib.lists.map (x: attrsets.nameValuePair x true) cfg.ignored_filetypes
      );
      ignore_buftypes = attrsets.listToAttrs (
        lib.lists.map (x: attrsets.nameValuePair x true) cfg.ignored_buffertypes
      );
      popup = {
        inherit (cfg) blend width;
        winhl =
          if (cfg.color != null)
          then "SpecsPopColor"
          else "PMenu";
        delay_ms = cfg.delay;
        inc_ms = cfg.increment;
        fader = helpers.mkRaw (
          if cfg.fader.builtin == null
          then cfg.fader.custom
          else ''require("specs").${cfg.fader.builtin}''
        );
        resizer = helpers.mkRaw (
          if cfg.resizer.builtin == null
          then cfg.resizer.custom
          else ''require("specs").${cfg.resizer.builtin}''
        );
      };
    };
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      highlight.SpecsPopColor.bg = mkIf (cfg.color != null) cfg.color;

      extraConfigLua = ''
        require('specs').setup(${setup})
      '';
    };
}
