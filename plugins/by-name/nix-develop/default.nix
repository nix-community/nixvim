{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.nix-develop;
in
{
  options.plugins.nix-develop = lib.nixvim.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "nix-develop.nvim";

    package = lib.mkPackageOption pkgs "nix-develop.nvim" {
      default = [
        "vimPlugins"
        "nix-develop-nvim"
      ];
    };

    ignoredVariables = mkOption {
      type = with types; attrsOf bool;
      default = { };
      description = "An attrs specifying the variables should be ignored.";
      example = {
        BASHOPTS = true;
        HOME = true;
        NIX_BUILD_TOP = true;
        SHELL = true;
        TMP = true;
      };
    };

    separatedVariables = mkOption {
      type = with types; attrsOf str;
      default = { };
      description = "An attrs specifying the separator to use for particular environment variables.";
      example = {
        PATH = ":";
        XDG_DATA_DIRS = ":";
      };
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];
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
