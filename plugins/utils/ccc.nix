{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "ccc";
  originalName = "ccc.nvim";
  defaultPackage = pkgs.vimPlugins.ccc-nvim;

  maintainers = [helpers.maintainers.JanKremer];

  settingsOptions = {
    default_color = helpers.defaultNullOpts.mkStr "#000000" ''
      The default color used when a color cannot be picked. It must be HEX format.
    '';

    highlight_mode =
      helpers.defaultNullOpts.mkEnum
      [
        "fg"
        "bg"
        "foreground"
        "background"
      ]
      "bg"
      ''
        Option to highlight text foreground or background. It is used to
        `output_line` and `highlighter`.
      '';

    lsp = helpers.defaultNullOpts.mkBool true ''
      Whether to enable LSP support. The color information is updated in the
      background and the result is used by `:CccPick` and highlighter.
    '';

    highlighter = {
      auto_enable = helpers.defaultNullOpts.mkBool false ''
        Whether to enable automatically on `BufEnter`.
      '';

      lsp = helpers.defaultNullOpts.mkBool true ''
        If true, highlight using LSP. If a language server with the color
        provider is not attached to a buffer, it falls back to highlight with
        pickers. See also `:help ccc-option-lsp`.
      '';
    };
  };

  settingsExample = {
    default_color = "#FFFFFF";
    highlight_mode = "fg";
    lsp = false;
    highlighter = {
      auto_enable = true;
      lsp = false;
    };
  };

  extraConfig = cfg: {opts.termguicolors = lib.mkDefault true;};
}
