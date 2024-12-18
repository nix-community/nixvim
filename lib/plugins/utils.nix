{ lib }:
{

  /**
    Apply an `extraConfig` definition, which should produce a `config` definition.
    As used by `mkVimPlugin` and `mkNeovimPlugin`.

    The result will be wrapped using a `mkIf` definition.
  */
  applyExtraConfig =
    {
      extraConfig,
      cfg,
      opts,
      enabled ? cfg.enable or (throw "`enabled` argument not provided and no `cfg.enable` option found."),
    }:
    let
      maybeApply = x: maybeFn: if builtins.isFunction maybeFn then maybeFn x else maybeFn;
    in
    lib.pipe extraConfig [
      (maybeApply cfg)
      (maybeApply opts)
      (lib.mkIf enabled)
    ];

  mkConfigAt =
    loc: def:
    let
      isOrder = loc._type or null == "order";
      withOrder = if isOrder then lib.modules.mkOrder loc.priority else lib.id;
      loc' = lib.toList (if isOrder then loc.content else loc);
    in
    lib.setAttrByPath loc' (withOrder def);
}
