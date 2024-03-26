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
            "bsfmt"
            "bslint"
            "cljstyle"
            "cueimports"
            # As of 2024-03-22, pkgs.d2 is broken
            # TODO: re-enable this test when fixed
            "d2_fmt"
            "erb_lint"
            "findent"
            "forge_fmt"
            "gccdiag"
            "gersemi"
            "markuplint"
            "mlint"
            "nginx_beautifier"
            "npm_groovy_lint"
            "ocdc"
            "packer"
            "perlimports"
            "pint"
            "pretty_php"
            "purs_tidy"
            "pyink"
            "reek"
            "regal"
            "remark"
            "rescript"
            "saltlint"
            "solhint"
            "spectral"
            "sqlfmt"
            "sql_formatter"
            "styler"
            "stylint"
            "swiftformat"
            "swiftlint"
            "textidote"
            "textlint"
            "twigcs"
            "vacuum"
            "yamlfix"
          ]
          ++ (
            pkgs.lib.optionals
            (pkgs.stdenv.isDarwin && pkgs.stdenv.isx86_64)
            [
              # As of 2024-03-27, pkgs.graalvm-ce (a dependency of pkgs.clj-kondo) is broken on x86_64-darwin
              # TODO: re-enable this test when fixed
              "clj_kondo"
              "rubyfmt"
            ]
          )
          ++ (
            pkgs.lib.optionals
            pkgs.stdenv.isDarwin
            [
              "clazy"
              "gdformat"
              "gdlint"
              "haml_lint"
              "verilator"
              "verible_verilog_format"
            ]
          )
          ++ (
            pkgs.lib.optionals
            pkgs.stdenv.isAarch64
            [
              "semgrep"
              "smlfmt"
              # As of 2024-03-11, swift-format is broken on aarch64
              # TODO: re-enable this test when fixed
              "swift_format"
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
