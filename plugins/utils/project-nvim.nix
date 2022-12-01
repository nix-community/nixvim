{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.plugins.project-nvim;
  helpers = import ../helpers.nix { inherit lib; };
in
{
  options.plugins.project-nvim = helpers.extraOptionsOptions // {
    enable = mkEnableOption "Enable project.nvim";

    manualMode = mkOption {
      type = types.nullOr types.bool;
      default = null;
    };

    detectionMethods = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
    };

    patterns = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
    };

    ignoreLsp = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
    };

    excludeDirs = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
    };

    showHidden = mkOption {
      type = types.nullOr types.bool;
      default = null;
    };

    silentChdir = mkOption {
      type = types.nullOr types.bool;
      default = null;
    };

    scopeChdir = mkOption {
      type = types.nullOr (types.enum [ "global" "tab" "win" ]);
      default = null;
    };

    dataPath = mkOption {
      type = types.nullOr (types.either types.str helpers.rawType);
      default = null;
    };

  };

  config =
    let
      options = {
        manual_mode = cfg.manualMode;
        detection_methods = cfg.detectionMethods;
        patterns = cfg.patterns;
        ignore_lsp = cfg.ignoreLsp;
        exclude_dirs = cfg.excludeDirs;
        show_hidden = cfg.showHidden;
        silent_chdir = cfg.silentChdir;
        scope_schdir = cfg.scopeChdir;
        data_path = cfg.dataPath;
      } // cfg.extraOptions;
    in
    mkIf cfg.enable {
      extraPlugins = [ pkgs.vimPlugins.project-nvim ];

      extraConfigLua = ''
        require('project_nvim').setup(${helpers.toLuaObject options})
      '';
    };
}
