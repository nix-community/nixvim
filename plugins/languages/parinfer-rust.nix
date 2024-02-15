{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "parinfer-rust";
  defaultPackage = pkgs.vimPlugins.parinfer-rust;
  globalPrefix = "parinfer_";

  maintainers = [lib.maintainers.GaetanLepage];

  settingsOptions = {
    mode = helpers.defaultNullOpts.mkEnumFirstDefault ["smart" "indent" "paren"] ''
      The mode used to process buffer changes.
    '';

    force_balance = helpers.defaultNullOpts.mkBool false ''
      In smart mode and indent mode, parinfer will sometimes leave unbalanced brackets around the
      cursor and fix them when the cursor moves away.
      When this option is set to `true`, the brackets will be fixed immediately (and fixed again
      when text is inserted).
    '';
  };
}
