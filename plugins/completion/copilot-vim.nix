{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.copilot-vim;
in {
  imports = [
    (lib.mkRenamedOptionModule ["plugins" "copilot"] ["plugins" "copilot-vim"])
  ];

  options = {
    plugins.copilot-vim = {
      enable = mkEnableOption "copilot.vim";

      package = helpers.mkPackageOption "copilot.vim" pkgs.vimPlugins.copilot-vim;

      filetypes = mkOption {
        type = types.attrsOf types.bool;
        description = "A dictionary mapping file types to their enabled status";
        default = {};
        example = literalExpression ''
          {
            "*" = false;
            python = true;
          }
        '';
      };

      proxy = helpers.defaultNullOpts.mkStr "" ''
        Tell Copilot what proxy server to use.
        Example: "localhost:3128"
      '';

      extraConfig = mkOption {
        type = types.attrs;
        description = ''
          The configuration options for copilot without the 'copilot_' prefix.
          Example: To set 'copilot_foo_bar' to 1, write
            extraConfig = {
              foo_bar = true;
            };
        '';
        default = {};
      };
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];

    globals = with cfg;
      mapAttrs' (name: nameValuePair ("copilot_" + name))
      (
        {
          node_command = "${pkgs.nodejs-18_x}/bin/node";
          inherit filetypes proxy;
        }
        // cfg.extraConfig
      );
  };
}
