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
      # sandbox-exec: pattern serialization length 159032 exceeds maximum (65535)
      enable = !pkgs.stdenv.isDarwin;

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

        unpackaged =
          [
            "blade_formatter"
            "blue"
            "brittany"
            "bsfmt"
            "bslint"
            "cljstyle"
            "cueimports"
            "curlylint"
            "dtsfmt"
            "erb_lint"
            "fixjson"
            "forge_fmt"
            "gccdiag"
            "gersemi"
            "gospel"
            "jshint"
            "jsonlint"
            "markdown_toc"
            "markuplint"
            "misspell"
            "mlint"
            "nginx_beautifier"
            "npm_groovy_lint"
            "ocdc"
            "packer"
            "perlimports"
            "pint"
            "pretty_php"
            "puglint"
            "purs_tidy"
            "pyflyby"
            "pyink"
            "pyproject_flake8"
            "reek"
            "regal"
            "remark"
            "rescript"
            "saltlint"
            "semistandardjs"
            "solhint"
            "spectral"
            "sqlfmt"
            "sql_formatter"
            "standardjs"
            "standardrb"
            "standardts"
            "styler"
            "stylint"
            "swiftformat"
            "swiftlint"
            "terrafmt"
            "textidote"
            "textlint"
            "twigcs"
            "vacuum"
            "xo"
            "yamlfix"
          ]
          ++ (
            pkgs.lib.optionals
            (pkgs.stdenv.isDarwin && pkgs.stdenv.isx86_64)
            [
              "rubyfmt"
              # Currently broken
              "lua_format"
              # Currently broken
              "zigfmt"
            ]
          )
          ++ (
            pkgs.lib.optionals
            pkgs.stdenv.isDarwin
            [
              "rpmspec"
              "clazy"
              "gdformat"
              "gdlint"
              "haml_lint"
              "verilator"
              "verible_verilog_format"
              # Broken due to a dependency
              "jsonnetfmt"
            ]
          )
          ++ (
            pkgs.lib.optionals
            pkgs.stdenv.isAarch64
            [
              "semgrep"
              "smlfmt"
            ]
          );

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
