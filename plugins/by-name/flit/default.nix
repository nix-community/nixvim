{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "flit";
  package = "flit-nvim";
  description = "f/F/t/T motions on steroids, building on the Leap interface.";

  maintainers = [ lib.maintainers.jolars ];

  settingsOptions = {
    keys =
      defaultNullOpts.mkAttrsOf types.str
        {
          f = "f";
          F = "F";
          t = "t";
          T = "T";
        }
        ''
          Key mappings.
        '';

    labeled_modes = defaultNullOpts.mkStr "v" ''
      A string like `"nv"`, `"nvo"`, `"o"`, etc.
    '';

    clever_repeat = defaultNullOpts.mkBool true ''
      Whether to repeat with the trigger key itself.
    '';

    multiline = defaultNullOpts.mkBool true ''
      Whether to enable multiline support.
    '';

    opts = defaultNullOpts.mkAttrsOf' {
      type = types.anything;
      pluginDefault = { };
      example = lib.literalExpression ''
        {
          equivalence_classes.__empty = null;
        }
      '';
      description = ''
        Like `leap`s similar argument (call-specific overrides).
      '';
    };
  };

  settingsExample = {
    keys = {
      f = "f";
      F = "F";
      t = "t";
      T = "T";
    };
    labeled_modes = "nv";
    multiline = true;
  };
}
