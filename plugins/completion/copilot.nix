{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.copilot;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options = {
    plugins.copilot = {
      enable = mkEnableOption "copilot";
      package = helpers.mkPackageOption "copilot" pkgs.vimPlugins.copilot-vim;
      filetypes = mkOption {
        type = types.attrsOf types.bool;
        description = "A dictionary mapping file types to their enabled status";
        default = {};
        example = literalExpression ''          {
                    "*": false,
                    python: true
                  }'';
      };
      proxy = mkOption {
        type = types.nullOr types.str;
        description = "Tell Copilot what proxy server to use.";
        default = null;
        example = "localhost:3128";
      };
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];
    globals =
      {
        copilot_node_command = "${pkgs.nodejs-16_x}/bin/node";
        copilot_filetypes = cfg.filetypes;
      }
      // (
        if cfg.proxy != null
        then {copilot_proxy = cfg.proxy;}
        else {}
      );
  };
}
