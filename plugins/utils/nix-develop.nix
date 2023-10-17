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
      };

      separatedVariables = mkOption {
        type = types.attrsOf types.str;
      };
    };

  config = let
    inherit (cfg) ignoredVariables separatedVariables;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];
      extraConfigLua = ''
        local ignored_variables = ${helpers.toLuaObject ignoredVariables}
        for ignoredVariable, shouldIgnore in ipairs(ignored_variables) do
        	require("nix-develop").ignored_variables[ignoredVariable] = shouldIgnore
        end

        local separated_variables = ${helpers.toLuaObject separatedVariables}
        for variable, separator in ipairs(separated_variables) do
        	require("nix-develop").separated_variables[variable] = separator
        end
      '';
    };
}
