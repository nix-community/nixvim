{
  lib,
  nixvimOptions,
}:
with lib; {
  mkSettingsOption = {
    pluginName ? null,
    options ? {},
    description ?
      if pluginName != null
      then "Options provided to the `require('${pluginName}').setup` function."
      else throw "mkSettingsOption: Please provide either a `pluginName` or `description`.",
    example ? null,
  }:
    nixvimOptions.mkSettingsOption {
      inherit options description example;
    };

  # TODO: DEPRECATED: use the `settings` option instead
  extraOptionsOptions = {
    extraOptions = mkOption {
      default = {};
      type = with types; attrsOf anything;
      description = ''
        These attributes will be added to the table parameter for the setup function.
        Typically, it can override NixVim's default settings.
      '';
    };
  };
}
