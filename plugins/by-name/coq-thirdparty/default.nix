{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.coq-thirdparty;
in
{
  options.plugins.coq-thirdparty = {
    enable = mkEnableOption "coq-thirdparty";

    package = lib.mkPackageOption pkgs "coq-thirdparty" {
      default = [
        "vimPlugins"
        "coq-thirdparty"
      ];
    };

    sources = mkOption {
      type = types.listOf (
        types.submodule {
          freeformType = types.attrs;

          options = {
            src = mkOption {
              type = types.str;
              description = "The name of the source";
            };

            short_name = mkOption {
              type = types.nullOr types.str;
              description = ''
                A short name for the source.
                If not specified, it is uppercase `src`.
              '';
              example = "nLUA";
              default = null;
            };
          };
        }
      );
      description = ''
        List of sources.
        Each source is a free-form type, so additional settings like `accept_key` may be specified even if they are not declared by nixvim.
      '';
      default = [ ];
      example = [
        {
          src = "nvimlua";
          short_name = "nLUA";
        }
        {
          src = "vimtex";
          short_name = "vTEX";
        }
        { src = "demo"; }
      ];
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];

    extraConfigLua = ''
      require('coq_3p')(${lib.nixvim.toLuaObject cfg.sources})
    '';
  };
}
