{
  lib,
  config,
  options,
  pkgs,
  ...
}:
let
  cfg = config.plugins.lsp.servers.rust_analyzer;
  opts = options.plugins.lsp.servers.rust_analyzer;

  enabled = config.plugins.lsp.enable && cfg.enable;

  newCfg = config.lsp.servers.rust_analyzer;
  newOpts =
    options.lsp.servers.valueMeta.configuration.options.rust_analyzer.valueMeta.configuration.options;

  optionDefaultPrio = (lib.mkOptionDefault null).priority;

  # Based on lib.modules.mkAliasAndWrapDefsWithPriority, but filters out null definition values.
  mkAliasForNonNullDefs =
    opt:
    let
      prio = opt.highestPrio or lib.modules.defaultOverridePriority;
      defs = lib.partition (v: v == null) opt.definitions;
      checked =
        if defs.right != [ ] && defs.wrong != [ ] then
          # Message from `lib.types.nullOr` → `merge.v2`:
          throw "The option `${opt}` is defined both null and not null, in ${lib.showFiles opt.files}."
        else
          # Non-null definitions
          defs.wrong;
    in
    lib.mkMerge (map (lib.mkOverride prio) checked);

in
{
  # When the legacy options `plugins.lsp.enable && plugins.lsp.servers.rust_analyzer.enable` are enabled,
  # these aliases bind with the new `lsp.servers.rust_analyzer` options.
  # Otherwise, these aliases only evaluate their own definitions/defaults.
  options.plugins.lsp.servers.rust_analyzer = {

    # Alias for `lsp.servers.rust_analyzer.cargo.enable`
    installCargo = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      apply =
        v:
        if enabled then
          if newOpts.cargo.enable.highestPrio < optionDefaultPrio then newCfg.cargo.enable else null
        else
          v;
      description = "Whether to install `cargo`.";
      defaultText = null; # effective default from `apply`
      example = true;
    };

    # Alias for `lsp.servers.rust_analyzer.cargo.package`
    cargoPackage = lib.mkPackageOption pkgs "cargo" { } // {
      apply = v: if enabled then newCfg.cargo.package else v;
    };

    # Alias for `lsp.servers.rust_analyzer.rustc.enable`
    installRustc = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      apply =
        v:
        if enabled then
          if newOpts.rustc.enable.highestPrio < optionDefaultPrio then newCfg.rustc.enable else null
        else
          v;
      description = "Whether to install `rustc`.";
      defaultText = null; # effective default from `apply`
      example = true;
    };

    # Alias for `lsp.servers.rust_analyzer.rustc.package`
    rustcPackage = lib.mkPackageOption pkgs "rustc" { } // {
      apply = v: if enabled then newCfg.rustc.package else v;
    };

    # Alias for `lsp.servers.rust_analyzer.rustfmt.enable`
    installRustfmt = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      apply =
        v:
        if enabled then
          if newOpts.rustfmt.enable.highestPrio < optionDefaultPrio then newCfg.rustfmt.enable else null
        else
          v;
      description = "Whether to install `rustfmt`.";
      defaultText = null; # effective default from `apply`
      example = true;
    };

    # Alias for `lsp.servers.rust_analyzer.rustfmt.package`
    rustfmtPackage = lib.mkPackageOption pkgs "rustfmt" { } // {
      apply = v: if enabled then newCfg.rustfmt.package else v;
    };
  };

  config = {
    # Legacy warnings, not to be migrated to the new LSP module
    warnings = lib.mkIf cfg.enable (
      lib.nixvim.mkWarnings "plugins.lsp.servers.rust_analyzer" [
        {
          when = cfg.installCargo == null;

          message = ''
            `rust_analyzer` relies on `cargo`.
            - Set `plugins.lsp.servers.rust_analyzer.installCargo = true` to install it automatically
              with Nixvim.
              You can customize which package to install by changing
              `plugins.lsp.servers.rust_analyzer.cargoPackage`.
            - Set `plugins.lsp.servers.rust_analyzer.installCargo = false` to not have it install
              through Nixvim.
              By doing so, you will dismiss this warning.
          '';
        }
        {
          when = cfg.installRustc == null;

          message = ''
            `rust_analyzer` relies on `rustc`.
            - Set `plugins.lsp.servers.rust_analyzer.installRustc = true` to install it automatically
              with Nixvim.
              You can customize which package to install by changing
              `plugins.lsp.servers.rust_analyzer.rustcPackage`.
            - Set `plugins.lsp.servers.rust_analyzer.installRustc = false` to not have it install
              through Nixvim.
              By doing so, you will dismiss this warning.
          '';
        }
      ]
    );

    # Propagate definitions to the new `lsp` module's options, when the legacy options are enabled.
    # Null definitions are not propagated to non-null options.
    lsp.servers.rust_analyzer = lib.mkIf enabled {
      cargo.enable = mkAliasForNonNullDefs opts.installCargo;
      cargo.package = lib.mkIf (opts.cargoPackage.highestPrio < optionDefaultPrio) (
        lib.modules.mkAliasAndWrapDefsWithPriority lib.id opts.cargoPackage
      );
      rustc.enable = mkAliasForNonNullDefs opts.installRustc;
      rustc.package = lib.mkIf (opts.rustcPackage.highestPrio < optionDefaultPrio) (
        lib.modules.mkAliasAndWrapDefsWithPriority lib.id opts.rustcPackage
      );
      rustfmt.enable = mkAliasForNonNullDefs opts.installRustfmt;
      rustfmt.package = lib.mkIf (opts.rustfmtPackage.highestPrio < optionDefaultPrio) (
        lib.modules.mkAliasAndWrapDefsWithPriority lib.id opts.rustfmtPackage
      );
    };
  };
}
