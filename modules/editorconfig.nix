{
  lib,
  config,
  ...
}:
with lib; {
  imports = [
    (lib.mkRenamedOptionModule ["plugins" "editorconfig" "enable"] ["editorconfig" "enable"])
    (lib.mkRemovedOptionModule ["plugins" "editorconfig" "package"] "editorconfig is now builtin, no plugin required")
  ];

  options.editorconfig = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "editorconfig plugin for neovim";
    };

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
    cfg = config.editorconfig;
  in {
    globals.editorconfig = mkIf (!cfg.enable) false;

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
