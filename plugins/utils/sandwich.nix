{
  lib,
  config,
  helpers,
  pkgs,
  ...
}:
with lib;
  helpers.vim-plugin.mkVimPlugin config {
    name = "sandwich";
    originalName = "vim-sandwich";
    defaultPackage = pkgs.vimPlugins.vim-sandwich;
    globalPrefix = "sandwich_";

    description = ''
      The `settings` option will not let you define the options starting with `sandwich#`.
      For those, you can directly use the `globals` option:
      ```nix
        globals."sandwich#magicchar#f#patterns" = [
          {
            header.__raw = "[[\<\%(\h\k*\.\)*\h\k*]]";
            bra = "(";
            ket = ")";
            footer = "";
          }
        ];
      ```
    '';

    maintainers = [maintainers.GaetanLepage];

    settingsOptions = {
      no_default_key_mappings = helpers.defaultNullOpts.mkBool false ''
        Whether to disable the default mappings.
      '';
    };

    settingsExample = {
      no_default_key_mappings = true;
      no_tex_ftplugin = true;
      no_vim_ftplugin = true;
    };
  }
