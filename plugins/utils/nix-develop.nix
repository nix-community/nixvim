{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.nix-develop;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.nix-develop =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "nix-develop.nvim";

      package = helpers.mkPackageOption "nix-develop.nvim" pkgs.vimPlugins.nix-develop-nvim;

      ignoredVariables = mkOption {
        type = types.attrsOf types.bool;
        default = {};
      };

      separatedVariables = mkOption {
        type = types.attrsOf types.str;
        default = {};
      };
    };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];
    extraConfigLua = ''
      local __ignored_variables = ${helpers.toLuaObject cfg.ignoredVariables}
      for ignoredVariable, shouldIgnore in ipairs(__ignored_variables) do
      	require("nix-develop").ignored_variables[ignoredVariable] = shouldIgnore
      end

      local __separated_variables = ${helpers.toLuaObject cfg.separatedVariables}
      for variable, separator in ipairs(__separated_variables) do
      	require("nix-develop").separated_variables[variable] = separator
      end
    '';
  };
}
