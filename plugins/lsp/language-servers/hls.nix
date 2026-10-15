{
  lib,
  pkgs,
  config,
  options,
  ...
}:
let
  cfg = config.plugins.lsp.servers.hls;
  opts = options.plugins.lsp.servers.hls;

  enabled = config.plugins.lsp.enable && cfg.enable;

  newCfg = config.lsp.servers.hls;
  newOpts = options.lsp.servers.valueMeta.configuration.options.hls.valueMeta.configuration.options;

  optionDefaultPrio = (lib.mkOptionDefault null).priority;

  # Based on lib.modules.mkAliasAndWrapDefsWithPriority, but filters out null definition values.
  # TODO: move to nixvim lib
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
  # When the legacy options `plugins.lsp.enable && plugins.lsp.servers.hls.enable` are enabled,
  # these aliases bind with the new `lsp.servers.hls` options.
  # Otherwise, these aliases only evaluate their own definitions/defaults.
  options.plugins.lsp.servers.hls = {

    # Alias for `lsp.servers.hls.ghc.enable`
    installGhc = lib.mkOption {
      type = with lib.types; nullOr bool;
      apply =
        v: if enabled && newOpts.ghc.enable.highestPrio < optionDefaultPrio then newCfg.ghc.enable else v;
      # A null default does not propagate to the new option, because we filter null definitions.
      default = null;
      example = true;
      description = "Whether to install `ghc`.";
    };

    # Alias for `lsp.servers.hls.ghc.package`
    ghcPackage = lib.mkPackageOption pkgs "ghc" { } // {
      apply = v: if enabled then newCfg.ghc.package else v;
    };
  };

  config = {
    warnings = lib.mkIf cfg.enable (
      lib.nixvim.mkWarnings "plugins.lsp.servers.hls" {
        when = cfg.installGhc == null;
        message = ''
          `hls` relies on `ghc` (the Glasgow Haskell Compiler).
          - Set `plugins.lsp.servers.hls.installGhc = true` to install it automatically with Nixvim.
            You can customize which package to install by changing `plugins.lsp.servers.hls.ghcPackage`.
          - Set `plugins.lsp.servers.hls.installGhc = false` to not have it install through Nixvim.
            By doing so, you will dismiss this warning.
        '';
      }
    );

    # Propagate definitions to the new `lsp` module's options, when the legacy options are enabled.
    # Null definitions are not propagated to non-null options.
    lsp.servers.hls = lib.mkIf enabled {
      ghc.enable = mkAliasForNonNullDefs opts.installGhc;
      ghc.package = lib.mkIf (opts.ghcPackage.highestPrio < optionDefaultPrio) (
        lib.modules.mkAliasAndWrapDefsWithPriority lib.id opts.ghcPackage
      );
    };
  };
}
