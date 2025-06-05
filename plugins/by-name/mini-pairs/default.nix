{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-pairs";
  moduleName = "mini.pairs";
  packPathName = "mini.pairs";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    mappings =
      defaultNullOpts.mkNullableWithRaw
        (types.submodule {
          freeformType =
            with types;
            attrsOf (
              either (enum [ false ]) (submodule {
                freeformType = with types; attrsOf anything;
                options = {
                  action = defaultNullOpts.mkEnum [ "open" "close" "closeopen" ] null ''
                    Action to perform:
                    - "open": Insert whole pair and move cursor inside
                    - "close": Jump over close character or insert it
                    - "closeopen": For symmetric pairs, jump over or insert pair
                  '';

                  pair = defaultNullOpts.mkStr null ''
                    Two character string representing the pair to be used.
                    Can contain multibyte characters.
                  '';

                  neigh_pattern = defaultNullOpts.mkStr ".." ''
                    Pattern for two neighborhood characters.
                    Character "\r" indicates line start, "\n" - line end.
                  '';

                  register =
                    defaultNullOpts.mkNullableWithRaw
                      (types.submodule {
                        freeformType = with types; attrsOf anything;
                        options = {
                          bs = defaultNullOpts.mkBool true ''
                            Whether this pair will be recognized by <BS>.
                          '';

                          cr = defaultNullOpts.mkBool true ''
                            Whether this pair will be recognized by <CR>.
                          '';
                        };
                      })
                      {
                        bs = true;
                        cr = true;
                      }
                      ''
                        Information about whether this pair will be recognized by special keys.
                      '';
                };
              })
            );
        })
        {
          "__rawKey__'('" = {
            action = "open";
            pair = "()";
            neigh_pattern = "[^\\].";
          };
          "__rawKey__'['" = {
            action = "open";
            pair = "[]";
            neigh_pattern = "[^\\].";
          };
          "__rawKey__'{'" = {
            action = "open";
            pair = "{}";
            neigh_pattern = "[^\\].";
          };
          "__rawKey__')'" = {
            action = "close";
            pair = "()";
            neigh_pattern = "[^\\].";
          };
          "__rawKey__']'" = {
            action = "close";
            pair = "[]";
            neigh_pattern = "[^\\].";
          };
          "__rawKey__'}'" = {
            action = "close";
            pair = "{}";
            neigh_pattern = "[^\\].";
          };
          "__rawKey__'\"'" = {
            action = "closeopen";
            pair = "\"\"";
            neigh_pattern = "[^\\].";
            register = {
              cr = false;
            };
          };
          "__rawKey__\"'\"" = {
            action = "closeopen";
            pair = "''";
            neigh_pattern = "[^%a\\].";
            register = {
              cr = false;
            };
          };
          "__rawKey__'`'" = {
            action = "closeopen";
            pair = "``";
            neigh_pattern = "[^\\].";
            register = {
              cr = false;
            };
          };
        }
        ''
          Global mappings. Each key maps to either:
          - `false` to disable the mapping for that key
          - A table with pair information containing action, pair, and optional settings

          By default:
          - Pairs are not inserted after `\` (backslash)
          - Quotes are not recognized by <CR> 
          - Single quote `'` does not insert pair after a letter
        '';

    modes =
      defaultNullOpts.mkNullableWithRaw
        (types.submodule {
          freeformType = with types; attrsOf anything;
          options = {
            command = defaultNullOpts.mkBool false ''
              Whether to create mappings in Command mode.
            '';

            insert = defaultNullOpts.mkBool true ''
              Whether to create mappings in Insert mode.
            '';

            terminal = defaultNullOpts.mkBool false ''
              Whether to create mappings in Terminal mode.
            '';
          };
        })
        {
          command = false;
          insert = true;
          terminal = false;
        }
        ''
          In which modes mappings from this config should be created.
        '';
  };

  settingsExample = {
    modes = {
      insert = true;
      command = true;
      terminal = false;
    };
  };
}
