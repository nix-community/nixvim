{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts nestedLiteralLua;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-statusline";
  moduleName = "mini.statusline";
  packPathName = "mini.statusline";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    content =
      defaultNullOpts.mkNullableWithRaw
        (types.submodule {
          freeformType = with types; attrsOf anything;
          options = {
            active = defaultNullOpts.mkRaw "nil" ''
              Content for active window.
            '';

            inactive = defaultNullOpts.mkRaw "nil" ''
              Content for inactive window(s).
            '';
          };
        })
        {
          active = nestedLiteralLua "nil";
          inactive = nestedLiteralLua "nil";
        }
        ''
          Content of statusline as functions which return statusline string.
          See `:h statusline` for details on statusline format and code of default contents (used instead of `nil`).
        '';

    use_icons = defaultNullOpts.mkBool true ''
      Whether to use icons by default.
    '';
  };

  settingsExample = {
    use_icons = false;
  };
}
