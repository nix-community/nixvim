{
  lib,
  helpers,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "otter";
  packPathName = "otter.nvim";
  package = "otter-nvim";

  maintainers = [ ];

  imports = [
    # TODO: introduced 2024-06-29; remove after 24.11
    (lib.mkRemovedOptionModule
      [
        "plugins"
        "otter"
        "addCmpSources"
      ]
      ''
        You should use the "cmp-nvim-lsp" source instead.
        To quote upstream's README:
        > If you previously used the otter nvim-cmp source, you can remove it, as the completion results now come directly via the cmp-nvim-lsp source together with other language servers.
      ''
    )
  ];

  settingsOptions = {
    lsp = {
      hover = {
        border = helpers.defaultNullOpts.mkListOf lib.types.str [
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

      diagnostic_update_events = helpers.defaultNullOpts.mkListOf' {
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
      set_filetype = helpers.defaultNullOpts.mkBool false ''
        If set to true, the filetype of the otterbuffers will be set.
        Otherwise only the autocommand of lspconfig that attaches
        the language server will be executed without setting the filetype.
      '';

      write_to_disk = helpers.defaultNullOpts.mkBool false ''
        Write `<path>.otter.<embedded language extension>` files
        to disk on save of main buffer.
        Useful for some linters that require actual files,
        otter files are deleted on quit or main buffer close.
      '';
    };

    strip_wrapping_quote_characters = helpers.defaultNullOpts.mkListOf lib.types.str [
      "'"
      "\""
      "\`"
    ] "";

    handle_leading_whitespace = helpers.defaultNullOpts.mkBool false ''
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
        config.plugins.treesitter.enable -> config.plugins.treesitter.settings.highlight.enable == null;

      message = ''
        You have enabled otter, but treesitter syntax highlighting is not enabled.
        Otter functionality might not work as expected without it. Make sure `plugins.treesitter.settings.highlight.enable` and `plugins.treesitter.enable` are enabled.
      '';
    };

    plugins.lsp.onAttach = lib.mkIf cfg.autoActivate ''
      require('otter').activate()
    '';
  };

}
