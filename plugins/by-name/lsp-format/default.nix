{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lsp-format";
  packPathName = "lsp-format.nvim";
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

  extraConfig = cfg: {
    warnings = lib.mkIf (!config.plugins.lsp.enable) [
      "You have enabled `plugins.lsp-format` but have `plugins.lsp` disabled."
    ];

    plugins.lsp = {
      onAttach =
        lib.mkIf (cfg.lspServersToEnable == "all") # Lua
          ''
            require("lsp-format").on_attach(client)
          '';

      servers = lib.optionalAttrs (lib.isList cfg.lspServersToEnable) (
        lib.genAttrs cfg.lspServersToEnable (serverName: {
          onAttach.function = # Lua
            ''
              require("lsp-format").on_attach(client)
            '';
        })
      );

    };
  };
}
