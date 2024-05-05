{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.lightline;
in
{
  options = {
    plugins.lightline = {
      enable = mkEnableOption "lightline";

      package = helpers.mkPackageOption "lightline" pkgs.vimPlugins.lightline-vim;

      colorscheme = mkOption {
        type = with types; nullOr str;
        default = config.colorscheme;
        description = "The colorscheme to use for lightline. Defaults to .colorscheme.";
        example = "gruvbox";
      };

      componentFunction = mkOption {
        default = null;
        type = with types; nullOr (attrsOf str);
        description = ''
          A list of function component definitions.

          You should define the functions themselves in extraConfig
        '';
        example = ''
          plugins.lightline = {
            enable = true;
            componentFunction = {
              readonly = "LightlineReadonly";
            };

            extraConfig = '''
              function! LightlineReadonly()
                return &readonly && &filetype !=# 'help' ? 'RO' : '''
              endfunction
            ''';
          };
        '';
      };

      component = mkOption {
        default = null;
        type = with types; nullOr (attrsOf str);
        description = "Lightline component definitions. Uses 'statusline' syntax. Consult :h 'statusline' for a list of what's available.";
      };

      active = mkOption {
        default = null;
        type = types.nullOr (
          types.submodule {
            options =
              let
                listType = with helpers.nixvimTypes; maybeRaw (listOf (listOf str));
              in
              {
                left = helpers.mkNullOrOption listType "List of components that will show up on the left side of the bar";

                right = helpers.mkNullOrOption listType "List of components that will show up on the right side of the bar";
              };
          }
        );
      };

      inactive = mkOption {
        default = null;
        type = types.nullOr (
          types.submodule {
            options =
              let
                listType = with helpers.nixvimTypes; maybeRaw (listOf (listOf str));
              in
              {
                left = helpers.mkNullOrOption listType "List of components that will show up on the left side of the bar";

                right = helpers.mkNullOrOption listType "List of components that will show up on the right side of the bar";
              };
          }
        );
      };

      modeMap = mkOption {
        type = with types; nullOr (attrsOf str);
        description = "Mode name mappings";
        default = null;
      };
    };
  };

  config =
    let
      configAttrs = filterAttrs (_: v: v != null) {
        inherit (cfg)
          colorscheme
          active
          inactive
          component
          componentFunction
          modeMap
          ;
      };
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];
      globals.lightline = mkIf (configAttrs != { }) configAttrs;
    };
}
