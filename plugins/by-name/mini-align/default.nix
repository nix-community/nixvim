{ lib, ... }:
let
  inherit (lib) literalExpression types;
  inherit (lib.nixvim) defaultNullOpts nestedLiteralLua;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-align";
  moduleName = "mini.align";
  packPathName = "mini.align";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    mappings =
      defaultNullOpts.mkNullableWithRaw
        (types.submodule {
          freeformType = with types; attrsOf anything;
          options = {
            start = defaultNullOpts.mkStr "ga" ''
              Mapping to start alignment without preview.
            '';

            start_with_preview = defaultNullOpts.mkStr "gA" ''
              Mapping to start alignment with preview.
            '';
          };
        })
        {
          start = "ga";
          start_with_preview = "gA";
        }
        ''
          Module mappings. Use empty string to disable one.
        '';

    modifiers =
      defaultNullOpts.mkAttrsOf types.rawLua
        (literalExpression ''
          {
            # Main option modifiers
            __rawKey__'s' = # <function: enter split pattern>;
            __rawKey__'j' = # <function: choose justify side>;
            __rawKey__'m' = # <function: enter merge delimiter>;

            # Modifiers adding pre-steps
            __rawKey__'f' = # <function: filter parts by entering Lua expression>;
            __rawKey__'i' = # <function: ignore some split matches>;
            __rawKey__'p' = # <function: pair parts>;
            __rawKey__'t' = # <function: trim parts>;

            # Delete some last pre-step
            "__rawKey__'<BS>'" = # <function: delete some last pre-step>;

            # Special configurations for common splits
            __rawKey__'=' = # <function: enhanced setup for '='>;
            __rawKey__',' = # <function: enhanced setup for ','>;
            __rawKey__'|' = # <function: enhanced setup for '|'>;
            __rawKey__' ' = # <function: enhanced setup for ' '>;
          }'')
        ''
          Table with single character keys and modifier function values.
          Each modifier function is called when corresponding modifier key is pressed
          and has signature `(steps, opts)` to modify alignment steps and options.
        '';

    options =
      defaultNullOpts.mkNullableWithRaw
        (types.submodule {
          freeformType = with types; attrsOf anything;
          options = {
            split_pattern = defaultNullOpts.mkStr "" ''
              Lua pattern(s) used to detect split matches and create parts
            '';

            justify_side =
              defaultNullOpts.mkNullableWithRaw
                (
                  let
                    options = [
                      "center"
                      "left"
                      "none"
                      "right"
                    ];
                  in
                  with types;
                  either (enum options) (listOf (enum options))
                )
                "left"
                ''
                  Which direction(s) alignment should be done.
                '';

            merge_delimiter = defaultNullOpts.mkStr "" ''
              Delimiter(s) to use when merging parts back to strings
            '';
          };
        })
        {
          split_pattern = "";
          justify_side = "left";
          merge_delimiter = "";
        }
        ''
          Default options controlling alignment process.
        '';

    steps =
      defaultNullOpts.mkNullableWithRaw
        (types.submodule {
          freeformType = with types; attrsOf anything;
          options = {
            pre_split = defaultNullOpts.mkListOf types.anything [ ] ''
              Array of steps to apply before split step
            '';

            split = defaultNullOpts.mkRaw "nil" ''
              Main split step (if nil, default is used)
            '';

            pre_justify = defaultNullOpts.mkListOf types.anything [ ] ''
              Array of steps to apply before justify step
            '';

            justify = defaultNullOpts.mkRaw "nil" ''
              Main justify step (if nil, default is used)
            '';

            pre_merge = defaultNullOpts.mkListOf types.anything [ ] ''
              Array of steps to apply before merge step
            '';

            merge = defaultNullOpts.mkRaw "nil" ''
              Main merge step (if nil, default is used)
            '';
          };
        })
        {
          pre_split = [ ];
          split = nestedLiteralLua "nil";
          pre_justify = [ ];
          justify = nestedLiteralLua "nil";
          pre_merge = [ ];
          merge = nestedLiteralLua "nil";
        }
        ''
          Default steps performing alignment process.
          Each step is a table with 'name' and 'action' fields.
        '';

    silent = defaultNullOpts.mkBool false ''
      Whether to disable showing non-error feedback.
      This also affects helper messages shown during user interaction.
    '';
  };

  settingsExample = {
    silent = true;
  };
}
