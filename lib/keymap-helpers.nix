{lib, ...}:
with lib; let
  helpers = import ../lib/helpers.nix {inherit lib;};
in rec {
  # These are the configuration options that change the behavior of each mapping.
  mapConfigOptions = {
    silent =
      helpers.defaultNullOpts.mkBool false
      "Whether this mapping should be silent. Equivalent to adding <silent> to a map.";

    nowait =
      helpers.defaultNullOpts.mkBool false
      "Whether to wait for extra input on ambiguous mappings. Equivalent to adding <nowait> to a map.";

    script =
      helpers.defaultNullOpts.mkBool false
      "Equivalent to adding <script> to a map.";

    expr =
      helpers.defaultNullOpts.mkBool false
      "Means that the action is actually an expression. Equivalent to adding <expr> to a map.";

    unique =
      helpers.defaultNullOpts.mkBool false
      "Whether to fail if the map is already defined. Equivalent to adding <unique> to a map.";

    noremap =
      helpers.defaultNullOpts.mkBool true
      "Whether to use the 'noremap' variant of the command, ignoring any custom mappings on the defined action. It is highly advised to keep this on, which is the default.";

    remap =
      helpers.defaultNullOpts.mkBool false
      "Make the mapping recursive. Inverses \"noremap\"";

    desc =
      helpers.mkNullOrOption types.str
      "A textual description of this keybind, to be shown in which-key, if you have it.";
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
    (
      map
      (
        {short, ...}: short
      )
      (attrValues modes)
    );

  # TODO: When `maps` will have to be deprecated (early December 2023), change this.
  # mapOptionSubmodule = {...} (no need for options... except for 'optionalAction')
  mkMapOptionSubmodule = {
    defaultMode ? "",
    withKeyOpt ? true,
    flatConfig ? false,
    actionIsOptional ? false,
  }:
    with types;
      either
      str
      (submodule {
        options =
          (
            if withKeyOpt
            then {
              key = mkOption {
                type = str;
                description = "The key to map.";
                example = "<C-m>";
              };
            }
            else {}
          )
          // {
            mode = mkOption {
              type = either modeEnum (listOf modeEnum);
              description = ''
                One or several modes.
                Use the short-names (`"n"`, `"v"`, ...).
                See `:h map-modes` to learn more.
              '';
              default = defaultMode;
              example = ["n" "v"];
            };

            action =
              if actionIsOptional
              then helpers.mkNullOrOption str "The action to execute"
              else
                mkOption {
                  type = str;
                  description = "The action to execute.";
                };

            lua = mkOption {
              type = bool;
              description = ''
                If true, `action` is considered to be lua code.
                Thus, it will not be wrapped in `""`.
              '';
              default = false;
            };
          }
          // (
            if flatConfig
            then mapConfigOptions
            else {
              options = mapConfigOptions;
            }
          );
      });

  # Correctly merge two attrs (partially) representing a mapping.
  mergeKeymap = defaults: keymap: let
    # First, merge the `options` attrs of both options.
    mergedOpts = (defaults.options or {}) // (keymap.options or {});
  in
    # Then, merge the root attrs together and add the previously merged `options` attrs.
    (defaults // keymap) // {options = mergedOpts;};

  # Given an attrs of key mappings (for a single mode), applies the defaults to each one of them.
  #
  # Example:
  # mkModeMaps { silent = true; } {
  #   Y = "y$";
  #   "<C-c>" = { action = ":b#<CR>"; silent = false; };
  # };
  #
  # would give:
  # {
  #   Y = {
  #     action = "y$";
  #     silent = true;
  #   };
  #   "<C-c>" = {
  #     action = ":b#<CR>";
  #     silent = false;
  #   };
  # };
  mkModeMaps = defaults:
    mapAttrs
    (
      key: action: let
        actionAttrs =
          if isString action
          then {inherit action;}
          else action;
      in
        defaults // actionAttrs
    );

  # Applies some default mapping options to a set of mappings
  #
  # Example:
  #   maps = mkMaps { silent = true; expr = true; } {
  #     normal = {
  #       ...
  #     };
  #     visual = {
  #       ...
  #     };
  #   }
  mkMaps = defaults:
    mapAttrs
    (
      name: modeMaps:
        mkModeMaps defaults modeMaps
    );

  # TODO deprecate `mkMaps` and `mkModeMaps` and leave only this one
  mkKeymaps = defaults:
    map
    (mergeKeymap defaults);
}
