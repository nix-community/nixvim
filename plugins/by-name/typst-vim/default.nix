{
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
lib.nixvim.plugins.mkVimPlugin {
  name = "typst-vim";
  packPathName = "typst.vim";
  globalPrefix = "typst_";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-02-20: remove 2024-04-20
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [
    "cmd"
    "pdfViewer"
    "concealMath"
    "autoCloseToc"
  ];

  extraOptions = {
    # Add the typst compiler to nixvim packages
    typstPackage = lib.mkPackageOption pkgs "typst" {
      nullable = true;
    };

    keymaps = {
      silent = mkOption {
        type = types.bool;
        description = "Whether typst-vim keymaps should be silent.";
        default = false;
      };

      watch = helpers.mkNullOrOption types.str "Keymap to preview the document and recompile on change.";
    };
  };

  extraConfig = cfg: {
    extraPackages = [ cfg.typstPackage ];

    keymaps =
      with cfg.keymaps;
      helpers.keymaps.mkKeymaps
        {
          mode = "n";
          options.silent = silent;
        }
        (
          optional (watch != null) {
            # mode = "n";
            key = watch;
            action = ":TypstWatch<CR>";
          }
        );
  };

  settingsOptions = {
    cmd = helpers.defaultNullOpts.mkStr "typst" ''
      Specifies the location of the Typst executable.
    '';

    pdf_viewer = helpers.mkNullOrOption types.str ''
      Specifies pdf viewer that `typst watch --open` will use.
    '';

    conceal_math = helpers.defaultNullOpts.mkFlagInt 0 ''
      Enable concealment for math symbols in math mode (i.e. replaces symbols with their actual
      unicode character).
      Warning: this can affect performance
    '';

    auto_close_toc = helpers.defaultNullOpts.mkFlagInt 0 ''
      Specifies whether TOC will be automatically closed after using it.
    '';
  };

  settingsExample = {
    cmd = "typst";
    conceal_math = 1;
    auto_close_toc = 1;
  };
}
