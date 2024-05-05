{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
  helpers.vim-plugin.mkVimPlugin config {
    name = "typst-vim";
    originalName = "typst.vim";
    defaultPackage = pkgs.vimPlugins.typst-vim;
    globalPrefix = "typst_";

    # Add the typst compiler to nixvim packages
    extraPackages = [pkgs.typst];

    maintainers = [maintainers.GaetanLepage];

    # TODO introduced 2024-02-20: remove 2024-04-20
    deprecateExtraConfig = true;
    optionsRenamedToSettings = [
      "cmd"
      "pdfViewer"
      "concealMath"
      "autoCloseToc"
    ];

    extraOptions = {
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
      keymaps = with cfg.keymaps;
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

      conceal_math = helpers.defaultNullOpts.mkBool false ''
        Enable concealment for math symbols in math mode (i.e. replaces symbols with their actual
        unicode character).
        Warning: this can affect performance
      '';

      auto_close_toc = helpers.defaultNullOpts.mkBool false ''
        Specifies whether TOC will be automatically closed after using it.
      '';
    };

    settingsExample = {
      cmd = "typst";
      conceal_math = true;
      auto_close_toc = true;
    };
  }
