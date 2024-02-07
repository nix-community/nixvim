{
  lib,
  nixvimOptions,
}:
with lib; {
  mkSettingsOption = pluginName: options:
    mkOption {
      type = with types;
        submodule {
          freeformType = with types; attrsOf anything;
          inherit options;
        };
      description = ''
        Options provided to the `require('${pluginName}').setup` function.
      '';
      default = {};
      example = {
        foo_bar = 42;
        hostname = "localhost:8080";
        callback.__raw = ''
          function()
            print('nixvim')
          end
        '';
      };
    };

  extraOptionsOptions = {
    extraOptions = mkOption {
      default = {};
      type = with types; attrsOf anything;
      description = ''
        These attributes will be added to the table parameter for the setup function.
        (Can override other attributes set by nixvim)
      '';
    };
  };
}
