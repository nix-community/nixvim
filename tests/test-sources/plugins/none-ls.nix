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
          ltrs.enable = true;
          shellcheck.enable = true;
          statix.enable = true;
        };
        diagnostics = {
          ansiblelint.enable = true;
          bandit.enable = true;
          checkstyle.enable = true;
          cppcheck.enable = true;
          deadnix.enable = true;
          eslint.enable = true;
          eslint_d.enable = true;
          flake8.enable = true;
          gitlint.enable = true;
          golangci_lint.enable = true;
          ktlint.enable = true;
          ltrs.enable = true;
          markdownlint.enable = true;
          shellcheck.enable = true;
          statix.enable = true;
          staticcheck.enable = true;
          typos.enable = true;
          vale.enable = true;
          vulture.enable = true;
          alex.enable = true;
          protolint.enable = true;
          revive.enable = true;
          hadolint.enable = true;
          luacheck.enable = true;
          mypy.enable = true;
          pylint.enable = true;
          write_good.enable = true;
          yamllint.enable = true;
          stylelint.enable = true;
        };
        formatting = {
          alejandra.enable = true;
          asmfmt.enable = true;
          astyle.enable = true;
          bean_format.enable = true;
          black.enable = true;
          # As of 2024-01-04, cbfmt is broken on darwin
          # TODO: re-enable this test when fixed
          cbfmt.enable = !pkgs.stdenv.isDarwin;
          eslint.enable = true;
          eslint_d.enable = true;
          fantomas.enable = true;
          fnlfmt.enable = true;
          fourmolu.enable = true;
          gofmt.enable = true;
          gofumpt.enable = true;
          goimports.enable = true;
          goimports_reviser.enable = true;
          golines.enable = true;
          google_java_format.enable = true;
          ktlint.enable = true;
          nixfmt.enable = true;
          nixpkgs_fmt.enable = true;
          phpcbf.enable = true;
          prettier.enable = true;
          prettierd.enable = true;
          shfmt.enable = true;
          stylua.enable = true;
          stylelint.enable = true;
          taplo.enable = true;
          isort.enable = true;
          jq.enable = true;
          markdownlint.enable = true;
          pint.enable = true;
          protolint.enable = true;
          rustfmt.enable = true;
          sqlfluff.enable = true;
          trim_newlines.enable = true;
          trim_whitespace.enable = true;
        };
      };
    };
  };
}
