{ lib, helpers }:
with lib;
rec {
  # These are the configuration options that change the behavior of each mapping.
  mapConfigOptions = {
    silent = helpers.defaultNullOpts.mkBool false "Whether this mapping should be silent. Equivalent to adding `<silent>` to a map.";

    nowait = helpers.defaultNullOpts.mkBool false "Whether to wait for extra input on ambiguous mappings. Equivalent to adding `<nowait>` to a map.";

    script = helpers.defaultNullOpts.mkBool false "Equivalent to adding `<script>` to a map.";

    expr = helpers.defaultNullOpts.mkBool false "Means that the action is actually an expression. Equivalent to adding `<expr>` to a map.";

    unique = helpers.defaultNullOpts.mkBool false "Whether to fail if the map is already defined. Equivalent to adding `<unique>` to a map.";

    noremap = helpers.defaultNullOpts.mkBool true "Whether to use the `noremap` variant of the command, ignoring any custom mappings on the defined action. It is highly advised to keep this on, which is the default.";

    remap = helpers.defaultNullOpts.mkBool false "Make the mapping recursive. Inverses `noremap`.";

    desc = helpers.mkNullOrOption types.str "A textual description of this keybind, to be shown in which-key, if you have it.";

    buffer = helpers.defaultNullOpts.mkBool false "Make the mapping buffer-local. Equivalent to adding `<buffer>` to a map.";
  };

  modes = {
    normal.short = "n";
    insert.short = "i";
    visual = {
      desc = "visual and select";
      short = "v";
    };
    visualOnly = {
      desc = "visual only";
      short = "x";
    };
    select.short = "s";
    terminal.short = "t";
    normalVisualOp = {
      desc = "normal, visual, select and operator-pending (same as plain 'map')";
      short = "";
    };
    operator.short = "o";
    lang = {
      desc = "normal, visual, select and operator-pending (same as plain 'map')";
      short = "l";
    };
    insertCommand = {
      desc = "insert and command-line";
      short = "!";
    };
    command.short = "c";
  };

  modeEnum =
    types.enum
      # ["" "n" "v" ...]
      (map ({ short, ... }: short) (attrValues modes));

  mapOptionSubmodule = mkMapOptionSubmodule { };

  # NOTE: options that have the deprecated `lua` sub-option must use `removeDeprecatedMapAttrs`
  # to ensure `lua` isn't evaluated when (e.g.) generating lua code.
  # Failure to do so will result in "option used but not defined" errors!
  deprecatedMapOptionSubmodule = mkMapOptionSubmodule { lua = true; };
  removeDeprecatedMapAttrs = v: builtins.removeAttrs v [ "lua" ];

  mkModeOption =
    default:
    mkOption {
      type = with types; either modeEnum (listOf modeEnum);
      description = ''
        One or several modes.
        Use the short-names (`"n"`, `"v"`, ...).
        See `:h map-modes` to learn more.
      '';
      inherit default;
      example = [
        "n"
        "v"
      ];
    };

  mkMapOptionSubmodule =
    {
      # Allow overriding defaults for key, action, mode, etc
      defaults ? { },

      # key and action can be true/false to enable/disable adding the option,
      # or an attrset to enable the option and add/override mkOption args.
      key ? true,
      action ? true,
      lua ? false, # WARNING: for historic use only - do not use in new options!

      # Allow passing additional options or modules to the submodule
      # Useful for plugin-specific features
      extraOptions ? { },
      extraModules ? [ ],
    }:
    with types;
    submodule (
      { config, options, ... }:
      {
        imports = extraModules;

        options =
          (optionalAttrs (isAttrs key || key) {
            key = mkOption (
              {
                type = str;
                description = "The key to map.";
                example = "<C-m>";
              }
              // (optionalAttrs (isAttrs key) key)
              // (optionalAttrs (defaults ? key) { default = defaults.key; })
            );
          })
          // (optionalAttrs (isAttrs action || action) {
            action = mkOption (
              {
                type = helpers.nixvimTypes.maybeRaw str;
                description = "The action to execute.";
                apply = v: if options.lua.isDefined or false && config.lua then helpers.mkRaw v else v;
              }
              // (optionalAttrs (isAttrs action) action)
              // (optionalAttrs (defaults ? action) { default = defaults.action; })
            );
          })
          // optionalAttrs (isAttrs lua || lua) {
            lua = mkOption (
              {
                type = bool;
                description = ''
                  If true, `action` is considered to be lua code.
                  Thus, it will not be wrapped in `""`.

                  This option is deprecated and will be removed in 24.11.
                  You should use a "raw" action instead, e.g. `action.__raw = ""`.
                '';
                visible = false;
              }
              // optionalAttrs (isAttrs lua) lua
            );
          }
          // {
            mode = mkModeOption defaults.mode or "";
            options = mapConfigOptions;
          }
          // extraOptions;
      }
    );

  # Correctly merge two attrs (partially) representing a mapping.
  mergeKeymap =
    defaults: keymap:
    let
      # First, merge the `options` attrs of both options.
      mergedOpts = (defaults.options or { }) // (keymap.options or { });
    in
    # Then, merge the root attrs together and add the previously merged `options` attrs.
    (defaults // keymap) // { options = mergedOpts; };

  mkKeymaps = defaults: map (mergeKeymap defaults);
}
