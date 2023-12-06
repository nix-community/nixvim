{pkgs, ...}: {
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
      sources = {
        code_actions = {
          eslint.enable = true;
          eslint_d.enable = true;
          gitsigns.enable = true;
          shellcheck.enable = true;
          statix.enable = true;
        };
        diagnostics = {
          ansiblelint.enable = true;
          cppcheck.enable = true;
          deadnix.enable = true;
          eslint.enable = true;
          eslint_d.enable = true;
          flake8.enable = true;
          gitlint.enable = true;
          golangci_lint.enable = true;
          ktlint.enable = true;
          markdownlint.enable = true;
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
          fantomas.enable = pkgs.stdenv.isLinux;
          fnlfmt.enable = true;
          fourmolu.enable = true;
          gofmt.enable = true;
          ktlint.enable = true;
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
