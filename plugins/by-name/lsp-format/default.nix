{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.plugins.lsp-format;
in
{
  options.plugins.lsp-format = lib.nixvim.neovim-plugin.extraOptionsOptions // {
    enable = lib.mkEnableOption "lsp-format.nvim";

    package = lib.mkPackageOption pkgs "lsp-format.nvim" {
      default = [
        "vimPlugins"
        "lsp-format-nvim"
      ];
    };

    setup = lib.mkOption {
      type =
        with lib.types;
        attrsOf (submodule {
          # Allow the user to provide other options
          freeformType = types.attrs;

          options = {
            exclude = lib.nixvim.mkNullOrOption (listOf str) "List of client names to exclude from formatting.";

            order = lib.nixvim.mkNullOrOption (listOf str) ''
              List of client names. Formatting is requested from clients in the following
              order: first all clients that are not in the `order` table, then the remaining
              clients in the order as they occur in the `order` table.
              (same logic as |vim.lsp.buf.formatting_seq_sync()|).
            '';

            sync = lib.nixvim.defaultNullOpts.mkBool false ''
              Whether to turn on synchronous formatting.
              The editor will block until formatting is done.
            '';

            force = lib.nixvim.defaultNullOpts.mkBool false ''
              If true, the format result will always be written to the buffer, even if the
              buffer changed.
            '';
          };
        });
      description = "The setup option maps |filetypes| to format options.";
      example = {
        go = {
          exclude = [ "gopls" ];
          order = [
            "gopls"
            "efm"
          ];
          sync = true;
          force = true;
        };
      };
      default = { };
    };

    lspServersToEnable = lib.mkOption {
      type =
        with lib.types;
        either (enum [
          "none"
          "all"
        ]) (listOf str);
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

  config =
    let
      setupOptions = cfg.setup // cfg.extraOptions;
    in
    lib.mkIf cfg.enable {
      warnings = lib.mkIf (!config.plugins.lsp.enable) [
        "You have enabled `plugins.lsp-format` but have `plugins.lsp` disabled."
      ];

      extraPlugins = [ cfg.package ];

      plugins.lsp = {
        onAttach = lib.mkIf (cfg.lspServersToEnable == "all") ''
          require("lsp-format").on_attach(client)
        '';

        servers =
          if (lib.isList cfg.lspServersToEnable) then
            lib.genAttrs cfg.lspServersToEnable (serverName: {
              onAttach.function = ''
                require("lsp-format").on_attach(client)
              '';
            })
          else
            { };
      };

      extraConfigLua = ''
        require("lsp-format").setup(${lib.nixvim.toLuaObject setupOptions})
      '';
    };
}
