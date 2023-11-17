{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.typst-vim;
in {
  options.plugins.typst-vim = {
    enable = mkEnableOption "typst.vim";

    package = helpers.mkPackageOption "typst-vim" pkgs.vimPlugins.typst-vim;

    cmd = helpers.defaultNullOpts.mkStr "typst" ''
      Specifies the location of the Typst executable.
    '';

    pdfViewer = helpers.mkNullOrOption types.str ''
      Specifies pdf viewer that `typst watch --open` will use.
    '';

    concealMath = helpers.defaultNullOpts.mkBool false ''
      Enable concealment for math symbols in math mode (i.e. replaces symbols with their actual
      unicode character).
      Warning: this can affect performance
    '';

    autoCloseToc = helpers.defaultNullOpts.mkBool false ''
      Specifies whether TOC will be automatically closed after using it.
    '';

    keymaps = {
      silent = mkOption {
        type = types.bool;
        description = "Whether typst-vim keymaps should be silent.";
        default = false;
      };

      watch =
        helpers.mkNullOrOption types.str
        "Keymap to preview the document and recompile on change.";
    };

    extraConfig = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        The configuration options for typst-vim without the 'typst_' prefix.
        Example: To set 'typst_foobar' to 1, write
        extraConfig = {
          foobar = true;
        };
      '';
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];

    # Add the typst compiler to nixvim packages
    extraPackages = with pkgs; [typst];

    globals =
      mapAttrs'
      (name: nameValuePair ("typst_" + name))
      (
        with cfg;
          {
            inherit cmd;
            pdf_viewer = pdfViewer;
            conceal_math = concealMath;
            auto_close_toc = autoCloseToc;
          }
          // extraConfig
      );

    keymaps = with cfg.keymaps;
      helpers.keymaps.mkKeymaps
      {
        mode = "n";
        options.silent = silent;
      }
      (
        optional
        (watch != null)
        {
          # mode = "n";
          key = watch;
          action = ":TypstWatch<CR>";
        }
      );
  };
}
