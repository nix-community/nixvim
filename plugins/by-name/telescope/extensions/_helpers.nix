lib: rec {
  # FIXME: don't manually put Default in the description
  # TODO: Comply with #603
  mkModeMappingsOption =
    mode: defaults:
    lib.mkOption {
      type = with lib.types; attrsOf strLuaFn;
      default = { };
      description = ''
        Keymaps in ${mode} mode.

        Default:
        ```nix
          ${defaults}
        ```
      '';
    };

  mkMappingsOption =
    { insertDefaults, normalDefaults }:
    {
      i = mkModeMappingsOption "insert" insertDefaults;
      n = mkModeMappingsOption "normal" normalDefaults;
    };
}
