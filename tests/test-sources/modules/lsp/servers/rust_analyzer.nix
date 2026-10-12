# Tests for `lsp.servers.rust_analyzer` tool-installation options (`cargo`, `rustc`, `rustfmt`)
# and their legacy `plugins.lsp.servers.rust_analyzer` aliases.
{
  # Enabling tools installs their packages into `extraPackages`.
  basic =
    { config, lib, ... }:
    let
      server = config.lsp.servers.rust_analyzer;
    in
    {
      test.runNvim = false;

      lsp.servers.rust_analyzer = {
        enable = true;
        cargo.enable = true;
        rustc.enable = true;
        rustfmt.enable = true;
      };

      assertions = [
        {
          assertion = server.enable;
          message = "rust analyzer should be enabled";
        }
        {
          assertion = server.cargo.enable;
          message = "rust analyzer install cargo should be enabled";
        }
        {
          assertion = server.rustc.enable;
          message = "rust analyzer install rustc should be enabled";
        }
        {
          assertion = server.rustfmt.enable;
          message = "rust analyzer install rustfmt should be enabled";
        }
        {
          assertion = lib.elem server.cargo.package config.extraPackages;
          message = "Expected cargo package to be in extraPackages.";
        }
        {
          assertion = lib.elem server.rustc.package config.extraPackages;
          message = "Expected rustc package to be in extraPackages.";
        }
        {
          assertion = lib.elem server.rustfmt.package config.extraPackages;
          message = "Expected rustfmt package to be in extraPackages.";
        }
        {
          # Legacy options are untouched when the legacy API is not enabled.
          assertion = config.plugins.lsp.servers.rust_analyzer.installCargo == null;
          message = "Legacy installCargo should stay null when the legacy API is not used.";
        }
      ];
    };

  # Ensure the server's `packageFallback` option applies to tools, via their per-tool default.
  package-fallback =
    { config, lib, ... }:
    let
      server = config.lsp.servers.rust_analyzer;
    in
    {
      test.buildNixvim = false;

      lsp.servers.rust_analyzer = {
        enable = true;
        packageFallback = true;
        cargo.enable = true;
        rustc.enable = true;
      };

      assertions = [
        {
          assertion = lib.elem server.cargo.package config.extraPackagesAfter;
          message = "Expected cargo package to be in extraPackagesAfter.";
        }
        {
          assertion = lib.elem server.rustc.package config.extraPackagesAfter;
          message = "Expected rustc package to be in extraPackagesAfter.";
        }
        {
          assertion = !(lib.elem server.cargo.package config.extraPackages);
          message = "Expected cargo package not to be in extraPackages.";
        }
        {
          assertion = !(lib.elem server.rustc.package config.extraPackages);
          message = "Expected rustc package not to be in extraPackages.";
        }
      ];
    };

  # `tool.packageFallback` options override the server's default `packageFallback`.
  per-tool-fallback =
    { config, lib, ... }:
    let
      server = config.lsp.servers.rust_analyzer;
    in
    {
      test.buildNixvim = false;

      lsp.servers.rust_analyzer = {
        enable = true;
        cargo.enable = true;
        cargo.packageFallback = true;
        rustc.enable = true;
      };

      assertions = [
        {
          assertion = lib.elem server.cargo.package config.extraPackagesAfter;
          message = "Expected cargo package to be in extraPackagesAfter.";
        }
        {
          assertion = !(lib.elem server.cargo.package config.extraPackages);
          message = "Expected cargo package not to be in extraPackages.";
        }
        {
          assertion = lib.elem server.rustc.package config.extraPackages;
          message = "Expected rustc package to be in extraPackages.";
        }
        {
          assertion = !(lib.elem server.rustc.package config.extraPackagesAfter);
          message = "Expected rustc package not to be in extraPackagesAfter.";
        }
      ];
    };

  # Test the two-way legacy aliases
  legacy-compat =
    { config, ... }:
    {
      test.runNvim = false;

      plugins.lsp = {
        enable = true;

        servers.rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
      };

      assertions = [
        {
          assertion = config.lsp.servers.rust_analyzer.enable;
          message = "rust analyzer should be enabled";
        }
        {
          assertion = config.lsp.servers.rust_analyzer.cargo.enable;
          message = "rust analyzer install cargo should be enabled";
        }
        {
          assertion = config.lsp.servers.rust_analyzer.rustc.enable;
          message = "rust analyzer install rustc should be enabled";
        }
        {
          assertion = !config.lsp.servers.rust_analyzer.rustfmt.enable;
          message = "rust analyzer install rustfmt should NOT be enabled";
        }
      ];
    };

  # Definitions of the new options are visible through the legacy aliases,
  # and dismiss the legacy warnings.
  legacy-compat-reverse =
    { config, ... }:
    let
      legacy = config.plugins.lsp.servers.rust_analyzer;
    in
    {
      test.runNvim = false;

      plugins.lsp = {
        enable = true;
        servers.rust_analyzer.enable = true;
      };

      lsp.servers.rust_analyzer = {
        cargo.enable = true;
        rustc.enable = false;
      };

      assertions = [
        {
          assertion = legacy.installCargo == true;
          message = "Legacy installCargo should read lsp.servers.rust_analyzer.cargo.enable.";
        }
        {
          assertion = legacy.installRustc == false;
          message = "Legacy installRustc should read lsp.servers.rust_analyzer.rustc.enable.";
        }
        {
          assertion = legacy.installRustfmt == null;
          message = "Legacy installRustfmt should stay null when rustfmt.enable is not defined.";
        }
      ];
    };

  # Legacy `plugins.lsp` explicit `null` definitions are not propagated to
  # the new non-nullable options, but still affect legacy behaviour.
  legacy-nullable-compat =
    { config, ... }:
    {
      test = {
        runNvim = false;
        # Explicit `installCargo = null` still triggers the legacy cargo warning
        warnings = expect: [
          (expect "count" 1)
          (expect "any" "`rust_analyzer` relies on `cargo`.")
        ];
      };

      plugins.lsp = {
        enable = true;

        servers.rust_analyzer = {
          enable = true;
          installCargo = null; # explicit null
          installRustc = true;
        };
      };

      assertions = [
        {
          assertion = config.lsp.servers.rust_analyzer.enable;
          message = "rust analyzer should be enabled";
        }
        {
          assertion = !config.lsp.servers.rust_analyzer.cargo.enable;
          message = "rust analyzer install cargo should NOT be enabled";
        }
        {
          assertion = config.lsp.servers.rust_analyzer.rustc.enable;
          message = "rust analyzer install rustc should be enabled";
        }
        {
          assertion = !config.lsp.servers.rust_analyzer.rustfmt.enable;
          message = "rust analyzer install rustfmt should NOT be enabled";
        }
      ];
    };
}
