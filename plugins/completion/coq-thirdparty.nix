{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.coq-thirdparty;
in {
  options.plugins.coq-thirdparty = {
    enable = mkEnableOption "coq-thirdparty";

    package = helpers.mkPackageOption "coq-thirdparty" pkgs.vimPlugins.coq-thirdparty;

    sources = mkOption {
      type = types.listOf (types.submodule {
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
      });
      description = "List of sources";
      default = [];
      example = [
        {
          src = "nvimlua";
          short_name = "nLUA";
        }
        {
          src = "vimtex";
          short_name = "vTEX";
        }
        {
          src = "copilot";
          short_name = "COP";
          accept_key = "<c-f>";
        }
        {src = "demo";}
      ];
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];

    extraConfigLua = ''
      require('coq_3p')(${helpers.toLuaObject cfg.sources})
    '';
  };
}
