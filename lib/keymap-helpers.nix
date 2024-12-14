{ lib }:
let
  inherit (lib) optionalAttrs isAttrs types;
  inherit (lib.nixvim) defaultNullOpts;
in
rec {
  # These are the configuration options that change the behavior of each mapping.
  mapConfigOptions = {
    silent = defaultNullOpts.mkBool false "Whether this mapping should be silent. Equivalent to adding `<silent>` to a map.";

    nowait = defaultNullOpts.mkBool false "Whether to wait for extra input on ambiguous mappings. Equivalent to adding `<nowait>` to a map.";

    script = defaultNullOpts.mkBool false "Equivalent to adding `<script>` to a map.";

    expr = defaultNullOpts.mkBool false "Means that the action is actually an expression. Equivalent to adding `<expr>` to a map.";

    unique = defaultNullOpts.mkBool false "Whether to fail if the map is already defined. Equivalent to adding `<unique>` to a map.";

    noremap = defaultNullOpts.mkBool true "Whether to use the `noremap` variant of the command, ignoring any custom mappings on the defined action. It is highly advised to keep this on, which is the default.";

    remap = defaultNullOpts.mkBool false "Make the mapping recursive. Inverses `noremap`.";

    desc = lib.nixvim.mkNullOrOption lib.types.str "A textual description of this keybind, to be shown in which-key, if you have it.";

    buffer = defaultNullOpts.mkBool false "Make the mapping buffer-local. Equivalent to adding `<buffer>` to a map.";
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
    lib.types.enum
      # ["" "n" "v" ...]
      (map ({ short, ... }: short) (lib.attrValues modes));

  mapOptionSubmodule = mkMapOptionSubmodule { };

  # NOTE: `lua` was deprecated 2024-05-26
  deprecatedMapOptionSubmodule = mkMapOptionSubmodule { lua = true; };

  mkModeOption =
    default:
    lib.mkOption {
      type = with lib.types; either modeEnum (listOf modeEnum);
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
    let
      type = types.submodule (
        { config, options, ... }:
        {
          imports = extraModules;

          options =
            (lib.optionalAttrs (isAttrs key || key) {
              key = lib.mkOption (
                {
                  type = types.str;
                  description = "The key to map.";
                  example = "<C-m>";
                }
                // (optionalAttrs (isAttrs key) key)
                // (optionalAttrs (defaults ? key) { default = defaults.key; })
              );
            })
            // (optionalAttrs (isAttrs action || action) {
              action = lib.mkOption (
                {
                  type = types.maybeRaw types.str;
                  description = "The action to execute.";
                  apply = v: if options.lua.isDefined or false && config.lua then lib.nixvim.mkRaw v else v;
                }
                // (optionalAttrs (isAttrs action) action)
                // (optionalAttrs (defaults ? action) { default = defaults.action; })
              );
            })
            // optionalAttrs (isAttrs lua || lua) {
              lua = lib.mkOption (
                {
                  type = types.bool;
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
    in
    type
    // {
      # Remove deprecated attrs from the keymap
      merge =
        loc: defs:
        builtins.removeAttrs (type.merge loc defs) [
          "lua"
        ];
    };

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
