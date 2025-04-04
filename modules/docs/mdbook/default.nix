{
  lib,
  config,
  pkgs,
  ...
}:
let
  settingsFormat = pkgs.formats.toml { };
  defaultSettings = {
    book = {
      language = "en";
      multilingual = false;
      title = "nixvim docs";
    };
    build.create-missing = false;
    output.html.site-url = "/";
    output.html.fold = {
      enable = true;
      level = 0;
    };
    preprocessor.alerts = { };
  };
in
{
  options.docs.html = {
    site = lib.mkOption {
      type = lib.types.package;
      description = "HTML docs rendered by mdbook.";
      readOnly = true;
    };
    settings = lib.mkOption {
      inherit (settingsFormat) type;
      description = ''
        Freeform settings written to `book.toml`.

        See MDBook's [Configuration](https://rust-lang.github.io/mdBook/format/configuration/index.html) docs.
      '';
      defaultText = defaultSettings;
    };
  };
  config.docs.html = {
    site = pkgs.callPackage ./package.nix {
      inherit (config.docs) src;
      inherit (config.docs.html) settings;
      menu = config.docs.menu.src;
      writeTOML = settingsFormat.generate;
    };
    settings = defaultSettings;
  };
}
