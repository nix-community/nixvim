{
  # Empty configuration
  empty = {
    plugins.null-ls.enable = true;
  };

  # Broken:
  # error: The option `plugins.null-ls.sources.formatting.beautysh' does not exist.
  #
  # beautysh = {
  #   plugins.null-ls = {
  #     enable = true;
  #     sources.formatting.beautysh.enable = true;
  #   };
  # };

  default = {
    plugins.null-ls = {
      enable = true;
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
      sources = {
        code_actions = {
          gitsigns.enable = true;
          shellcheck.enable = true;
          statix.enable = true;
        };
        diagnostics = {
          cppcheck.enable = true;
          flake8.enable = true;
          gitlint.enable = true;
          shellcheck.enable = true;
          statix.enable = true;
          deadnix.enable = true;
        };
        formatting = {
          alejandra.enable = true;
          black.enable = true;
          cbfmt.enable = true;
          fnlfmt.enable = true;
          fourmolu.enable = true;
          nixfmt.enable = true;
          phpcbf.enable = true;
          prettier.enable = true;
          shfmt.enable = true;
          stylua.enable = true;
          taplo.enable = true;
          nixpkgs_fmt.enable = true;
        };
      };
    };
  };
}
