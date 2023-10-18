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
          eslint.enable = true;
          eslint_d.enable = true;
          gitsigns.enable = true;
          shellcheck.enable = true;
          statix.enable = true;
        };
        diagnostics = {
          cppcheck.enable = true;
          deadnix.enable = true;
          eslint.enable = true;
          eslint_d.enable = true;
          flake8.enable = true;
          gitlint.enable = true;
          shellcheck.enable = true;
          statix.enable = true;
          vale.enable = true;
          vulture.enable = true;
          alex.enable = true;
          protolint.enable = true;
          hadolint.enable = true;
          luacheck.enable = true;
          mypy.enable = true;
          pylint.enable = true;
        };
        formatting = {
          alejandra.enable = true;
          black.enable = true;
          cbfmt.enable = true;
          eslint.enable = true;
          eslint_d.enable = true;
          fnlfmt.enable = true;
          fourmolu.enable = true;
          gofmt.enable = true;
          nixfmt.enable = true;
          nixpkgs_fmt.enable = true;
          phpcbf.enable = true;
          prettier.enable = true;
          prettier_d_slim.enable = true;
          shfmt.enable = true;
          stylua.enable = true;
          taplo.enable = true;
          isort.enable = true;
          jq.enable = true;
          markdownlint.enable = true;
          protolint.enable = true;
          rustfmt.enable = true;
          sqlfluff.enable = true;
        };
      };
    };
  };
}
