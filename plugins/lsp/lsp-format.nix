{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.lsp-format;
in {
  options.plugins.lsp-format =
    helpers.neovim-plugin.extraOptionsOptions
    // {
      enable = mkEnableOption "lsp-format.nvim";

      package = helpers.mkPackageOption "lsp-format.nvim" pkgs.vimPlugins.lsp-format-nvim;

      setup = mkOption {
        type = with types;
          attrsOf
          (submodule {
            # Allow the user to provide other options
            freeformType = types.attrs;

            options = {
              exclude =
                helpers.mkNullOrOption (listOf str)
                "List of client names to exclude from formatting.";

              order =
                helpers.mkNullOrOption (listOf str)
                ''
                  List of client names. Formatting is requested from clients in the following
                  order: first all clients that are not in the `order` table, then the remaining
                  clients in the order as they occur in the `order` table.
                  (same logic as |vim.lsp.buf.formatting_seq_sync()|).
                '';

              sync = helpers.defaultNullOpts.mkBool false ''
                Whether to turn on synchronous formatting.
                The editor will block until formatting is done.
              '';

              force = helpers.defaultNullOpts.mkBool false ''
                If true, the format result will always be written to the buffer, even if the
                buffer changed.
              '';
            };
          });
        description = "The setup option maps |filetypes| to format options.";
        example = {
          gopls = {
            exclude = ["gopls"];
            order = ["gopls" "efm"];
            sync = true;
            force = true;
          };
        };
        default = {};
      };

      lspServersToEnable = mkOption {
        type = with types; either (enum ["none" "all"]) (listOf str);
        default = "all";
        description = ''
          Choose the LSP servers for which lsp-format should be enabled.

          Possible values:
          - "all" (default): Enable formatting for all language servers
          - "none": Do not enable formatting on any language server.
            You might choose this if for some reason you want to manually call
            `require("lsp-format").on_attach(client)` in the `onAttach` function of your language
            servers.
          - list of LS names: Manually choose the servers by name
        '';
        example = [
          "efm"
          "gopls"
        ];
      };
    };

  config = let
    setupOptions = cfg.setup // cfg.extraOptions;
  in
    mkIf cfg.enable {
      warnings = mkIf (!config.plugins.lsp.enable) [
        "You have enabled `plugins.lsp-format` but have `plugins.lsp` disabled."
      ];

      extraPlugins = [cfg.package];

      plugins.lsp = {
        onAttach = mkIf (cfg.lspServersToEnable == "all") ''
          require("lsp-format").on_attach(client)
        '';

        servers =
          if (isList cfg.lspServersToEnable)
          then
            genAttrs
            cfg.lspServersToEnable
            (
              serverName: {
                onAttach.function = ''
                  require("lsp-format").on_attach(client)
                '';
              }
            )
          else {};
      };

      extraConfigLua = ''
        require("lsp-format").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
