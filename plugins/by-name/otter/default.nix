{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "otter";
  package = "otter-nvim";
  description = "A Neovim plugin for writing and running embedded languages in your code.";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  # `require("otter").setup()` must run **BEFORE** quarto
  # https://github.com/quarto-dev/quarto-nvim/issues/187
  configLocation = lib.mkOrder 900 "extraConfigLua";

  settingsOptions = {
    lsp = {
      hover = {
        border = lib.nixvim.defaultNullOpts.mkListOf lib.types.str [
          "╭"
          "─"
          "╮"
          "│"
          "╯"
          "─"
          "╰"
          "│"
        ] "";
      };

      diagnostic_update_events = lib.nixvim.defaultNullOpts.mkListOf' {
        type = lib.types.str;
        pluginDefault = [ "BufWritePost" ];
        description = ''
          `:h events` that cause the diagnostics to update.

          See example for less performant but more instant diagnostic updates.
        '';
        example = [
          "BufWritePost"
          "InsertLeave"
          "TextChanged"
        ];
      };
    };

    buffers = {
      set_filetype = lib.nixvim.defaultNullOpts.mkBool false ''
        If set to true, the filetype of the otterbuffers will be set.
        Otherwise only the autocommand of lspconfig that attaches
        the language server will be executed without setting the filetype.
      '';

      write_to_disk = lib.nixvim.defaultNullOpts.mkBool false ''
        Write `<path>.otter.<embedded language extension>` files
        to disk on save of main buffer.
        Useful for some linters that require actual files,
        otter files are deleted on quit or main buffer close.
      '';
    };

    strip_wrapping_quote_characters = lib.nixvim.defaultNullOpts.mkListOf lib.types.str [
      "'"
      "\""
      "\`"
    ] "";

    handle_leading_whitespace = lib.nixvim.defaultNullOpts.mkBool false ''
      Otter may not work the way you expect when entire code blocks are indented (eg. in Org files).
      When true, otter handles these cases fully. This is a (minor) performance hit.
    '';
  };

  extraOptions = {
    autoActivate = lib.mkOption {
      type = lib.types.bool;
      description = "When enabled, activate otter automatically when lsp is attached.";
      default = true;
    };
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.otter" {
      when =
        let
          inherit (config.plugins) treesitter;
          highlightEnabled = treesitter.highlight.enable || (treesitter.settings.highlight.enable or false);
        in
        !(treesitter.enable && highlightEnabled);

      message = ''
        You have enabled otter, but treesitter syntax highlighting is not enabled.
        Otter functionality might not work as expected without it. Make sure `plugins.treesitter.highlight.enable` and `plugins.treesitter.enable` are enabled.
      '';
    };

    lsp.onAttach = lib.mkIf cfg.autoActivate ''
      require('otter').activate()
    '';
  };

}
