{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lsp-format";
  package = "lsp-format-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  # TODO: added 10-22-2024 remove after 24.11
  deprecateExtraOptions = true;
  imports = [
    (lib.mkRenamedOptionModule
      [
        "plugins"
        "lsp-format"
        "setup"
      ]
      [
        "plugins"
        "lsp-format"
        "settings"
      ]
    )
  ];

  description = ''
    A wrapper around Neovims native LSP formatting.

    ---

    ## Configuring a Language

    `lsp-format` uses a table defining which lsp servers to use for each language.


    - `exclude` is a table of LSP servers that should not format the buffer.
      - Alternatively, you can also just not call `on_attach` for the clients you don't want to use for
        formatting.
    - `order` is a table that determines the order formatting is requested from the LSP server.
    - `sync` turns on synchronous formatting. The editor will block until the formatting is done.
    - `force` will write the format result to the buffer, even if the buffer changed after the format request started.
  '';

  settingsExample = {
    go = {
      exclude = [ "gopls" ];
      order = [
        "gopls"
        "efm"
      ];
      sync = true;
      force = true;
    };
    typescript = {
      tab_width.__raw = ''
        function()
          return vim.opt.shiftwidth:get()
        end'';
    };
    yaml = {
      tab_width = 2;
    };
  };

  extraOptions = {
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
          `require("lsp-format").on_attach(client)`.
        - list of LS names: Manually choose the servers by name
      '';
      example = [
        "efm"
        "gopls"
      ];
    };
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.lsp-format" {
      when = !(config.plugins.lsp.enable || config.plugins.lspconfig.enable);
      message = ''
        This plugin requires either `plugins.lsp` or `plugins.lspconfig` to be enabled.
      '';
    };

    lsp.onAttach =
      let
        toLua = lib.nixvim.lua.toLua' {
          multiline = false;
        };

        wrapLua =
          lua:
          if cfg.lspServersToEnable == "all" then
            lua
          else if lib.isList cfg.lspServersToEnable then
            # lua
            ''
              if vim.list_contains(${toLua cfg.lspServersToEnable}, client.name) then
                ${lib.removeSuffix "\n" lua}
              end
            ''
          else
            throw "Unhandled value for `lspServersToEnable`: ${
              lib.generators.toPretty { } cfg.lspServersToEnable
            }";
      in
      lib.mkIf (cfg.lspServersToEnable != "none") (wrapLua ''
        require("lsp-format").on_attach(client, bufnr)
      '');
  };
}
