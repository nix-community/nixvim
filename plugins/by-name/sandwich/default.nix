{
  lib,
  ...
}:
with lib;
lib.nixvim.plugins.mkVimPlugin {
  name = "sandwich";
  package = "vim-sandwich";
  globalPrefix = "sandwich_";

  description = ''
    `sandwich.vim` is a plugin that makes it super easy to work with stuff that comes in
    pairs, like brackets, quotes, and even HTML or XML tags.

    ---

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

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    no_default_key_mappings = lib.nixvim.defaultNullOpts.mkFlagInt 0 ''
      Whether to disable the default mappings.
    '';
  };

  settingsExample = {
    no_default_key_mappings = 1;
    no_tex_ftplugin = 1;
    no_vim_ftplugin = 1;
  };
}
