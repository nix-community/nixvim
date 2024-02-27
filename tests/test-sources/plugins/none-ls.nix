{
  pkgs,
  nonels-sources-options,
  ...
}: {
  # Empty configuration
  empty = {
    plugins.none-ls.enable = true;
  };

  # Broken:
  # error: The option `plugins.none-ls.sources.formatting.beautysh' does not exist.
  #
  # beautysh = {
  #   plugins.none-ls = {
  #     enable = true;
  #     sources.formatting.beautysh.enable = true;
  #   };
  # };

  with-lsp-format = {
    plugins = {
      lsp.enable = true;
      lsp-format.enable = true;
      none-ls = {
        enable = true;
        enableLspFormat = true;
      };
    };
  };

  default = {
    plugins.none-ls = {
      enable = true;

      enableLspFormat = false;
      border = null;
      cmd = ["nvim"];
      debounce = 250;
      debug = false;
      defaultTimeout = 5000;
      diagnosticConfig = null;
      diagnosticsFormat = "#{m}";
      fallbackSeverity = "error";
      logLevel = "warn";
      notifyFormat = "[null-ls] %s";
      onAttach = null;
      onInit = null;
      onExit = null;
      rootDir = null;
      shouldAttach = null;
      tempDir = null;
      updateInInsert = false;
      sources = let
        options = nonels-sources-options.options.plugins.none-ls.sources;

        unpackaged = [
          "pint"
        ];

        sources = pkgs.lib.mapAttrs (_: sources:
          pkgs.lib.mapAttrs (source: _:
            {
              enable = true;
            }
            // pkgs.lib.optionalAttrs (builtins.elem source unpackaged) {
              package = null;
            })
          sources)
        options;
      in
        sources;
    };
  };
}
