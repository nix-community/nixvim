# Tests for `lsp.servers.hls` tool-installation options (`ghc`)
# and their legacy `plugins.lsp.servers.hls` aliases.
{
  # Enabling ghc installs its package into `extraPackages`.
  basic =
    { config, lib, ... }:
    let
      server = config.lsp.servers.hls;
    in
    {
      test.runNvim = false;

      lsp.servers.hls = {
        enable = true;
        ghc.enable = true;
      };

      assertions = [
        {
          assertion = server.enable;
          message = "hls should be enabled";
        }
        {
          assertion = server.ghc.enable;
          message = "hls install ghc should be enabled";
        }
        {
          assertion = lib.elem server.ghc.package config.extraPackages;
          message = "Expected ghc package to be in extraPackages.";
        }
        {
          # Legacy options are untouched when the legacy API is not enabled.
          assertion = config.plugins.lsp.servers.hls.installGhc == null;
          message = "Legacy installGhc should stay null when the legacy API is not used.";
        }
      ];
    };

  # Ensure the server's `packageFallback` option applies to ghc, via ghc's default.
  package-fallback =
    { config, lib, ... }:
    let
      server = config.lsp.servers.hls;
    in
    {
      test.buildNixvim = false;

      lsp.servers.hls = {
        enable = true;
        packageFallback = true;
        ghc.enable = true;
      };

      assertions = [
        {
          assertion = lib.elem server.ghc.package config.extraPackagesAfter;
          message = "Expected ghc package to be in extraPackagesAfter.";
        }
        {
          assertion = !(lib.elem server.ghc.package config.extraPackages);
          message = "Expected ghc package not to be in extraPackages.";
        }
      ];
    };

  # `ghc.packageFallback` options override the server's default `packageFallback`.
  ghc-explicit-fallback =
    { config, lib, ... }:
    let
      server = config.lsp.servers.hls;
    in
    {
      test.buildNixvim = false;

      lsp.servers.hls = {
        enable = true;
        ghc.enable = true;
        ghc.packageFallback = true;
      };

      assertions = [
        {
          assertion = lib.elem server.ghc.package config.extraPackagesAfter;
          message = "Expected ghc package to be in extraPackagesAfter.";
        }
        {
          assertion = !(lib.elem server.ghc.package config.extraPackages);
          message = "Expected ghc package not to be in extraPackages.";
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

        servers.hls = {
          enable = true;
          installGhc = true;
        };
      };

      assertions = [
        {
          assertion = config.lsp.servers.hls.enable;
          message = "hls should be enabled";
        }
        {
          assertion = config.lsp.servers.hls.ghc.enable;
          message = "hls install ghc should be enabled";
        }
      ];
    };

  # Definitions of the new options are visible through the legacy aliases,
  # and dismiss the legacy warnings.
  legacy-compat-reverse =
    { config, ... }:
    let
      legacy = config.plugins.lsp.servers.hls;
    in
    {
      test.runNvim = false;

      plugins.lsp = {
        enable = true;
        servers.hls.enable = true;
      };

      lsp.servers.hls = {
        ghc.enable = true;
      };

      assertions = [
        {
          assertion = legacy.installGhc == true;
          message = "Legacy installGhc should read lsp.servers.hls.ghc.enable.";
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
        # Explicit `installGhc = null` still triggers the legacy ghc warning
        warnings = expect: [
          (expect "count" 1)
          (expect "any" "`hls` relies on `ghc`")
        ];
      };

      plugins.lsp = {
        enable = true;

        servers.hls = {
          enable = true;
          installGhc = null; # explicit null
        };
      };

      assertions = [
        {
          assertion = config.lsp.servers.hls.enable;
          message = "hls should be enabled";
        }
        {
          assertion = !config.lsp.servers.hls.ghc.enable;
          message = "hls install ghc should NOT be enabled";
        }
      ];
    };
}
