{
  lib,
  config,
  pkgs,
  ...
} @ args:
with lib; let
  # TODO: Migrate to builtin editorconfig in neovim 0.9
  helpers = import ../helpers.nix args;
in {
  options.plugins.editorconfig = {
    enable = mkEnableOption "editorconfig plugin for neovim";

    package = helpers.mkPackageOption "editorconfig.nvim" pkgs.vimPlugins.editorconfig-nvim;

    properties = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = ''
        The table key is a property name and the value is a callback function which accepts the
        number of the buffer to be modified, the value of the property in the .editorconfig file,
        and (optionally) a table containing all of the other properties and their values (useful
        for properties which depend on other properties). The value is always a string and must be
        coerced if necessary.
      '';
      example = {
        foo = ''
          function(bufnr, val, opts)
            if opts.charset and opts.charset ~= "utf-8" then
              error("foo can only be set when charset is utf-8", 0)
            end
            vim.b[bufnr].foo = val
          end
        '';
      };
    };
  };

  config = let
    cfg = config.plugins.editorconfig;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = let
        mkProperty = name: function: ''
          __editorconfig.properties.${name} = ${function}
        '';
        propertiesString = lib.concatLines (lib.mapAttrsToList mkProperty cfg.properties);
      in
        mkIf (propertiesString != "" && cfg.enable) ''
          do
            local __editorconfig = require('editorconfig')

            ${propertiesString}
          end
        '';
    };
}
