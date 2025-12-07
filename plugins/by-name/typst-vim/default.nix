{
  lib,
  ...
}:
let
  inherit (lib) types;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "typst-vim";
  globalPrefix = "typst_";
  description = "A Neovim plugin for Typst, a modern typesetting system.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [ "typst" ];

  extraOptions = {
    keymaps = {
      silent = lib.mkOption {
        type = types.bool;
        description = "Whether typst-vim keymaps should be silent.";
        default = false;
      };

      watch = lib.nixvim.mkNullOrOption types.str "Keymap to preview the document and recompile on change.";
    };
  };

  extraConfig = cfg: {
    keymaps =
      with cfg.keymaps;
      lib.nixvim.keymaps.mkKeymaps
        {
          mode = "n";
          options.silent = silent;
        }
        (
          lib.optional (watch != null) {
            # mode = "n";
            key = watch;
            action = ":TypstWatch<CR>";
          }
        );
  };

  settingsOptions = {
    cmd = lib.nixvim.defaultNullOpts.mkStr "typst" ''
      Specifies the location of the Typst executable.
    '';

    pdf_viewer = lib.nixvim.mkNullOrOption types.str ''
      Specifies pdf viewer that `typst watch --open` will use.
    '';

    conceal_math = lib.nixvim.defaultNullOpts.mkFlagInt 0 ''
      Enable concealment for math symbols in math mode (i.e. replaces symbols with their actual
      unicode character).
      Warning: this can affect performance
    '';

    auto_close_toc = lib.nixvim.defaultNullOpts.mkFlagInt 0 ''
      Specifies whether TOC will be automatically closed after using it.
    '';
  };

  settingsExample = {
    cmd = "typst";
    conceal_math = 1;
    auto_close_toc = 1;
  };
}
