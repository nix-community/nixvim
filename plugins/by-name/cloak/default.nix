{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "cloak";
  packPathName = "cloak.nvim";
  package = "cloak-nvim";
  description = "Cloak allows you to overlay *'s over defined patterns.";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    enabled = helpers.defaultNullOpts.mkBool true ''
      Whether to enable the plugin.
    '';

    cloak_character = helpers.defaultNullOpts.mkStr "*" ''
      Define the cloak character.
    '';

    highlight_group = helpers.defaultNullOpts.mkStr "Comment" ''
      The applied highlight group (colors) on the cloaking, see `:h highlight`.
    '';

    cloak_length = helpers.mkNullOrOption types.ints.unsigned ''
      Provide a number if you want to hide the true length of the value.
      Applies the length of the replacement characters for all matched patterns, defaults to the
      length of the matched pattern.
    '';

    try_all_patterns = helpers.defaultNullOpts.mkBool true ''
      Whether it should try every pattern to find the best fit or stop after the first.
    '';

    cloak_telescope = helpers.defaultNullOpts.mkBool true ''
      Set to true to cloak Telescope preview buffers.
      (Required feature not in 0.1.x)
    '';

    patterns =
      helpers.defaultNullOpts.mkListOf
        (types.submodule {
          options = {
            file_pattern = helpers.defaultNullOpts.mkNullable (with types; either str (listOf str)) ".env*" ''
              One or several patterns to match against.
              They should be valid autocommand patterns.
            '';

            cloak_pattern = helpers.defaultNullOpts.mkNullable (with types; either str (listOf str)) "=.+" ''
              One or several patterns to cloak.

              Example: `[":.+" "-.+"]` for yaml files.
            '';

            replace = helpers.mkNullOrOption types.anything ''
              A function, table or string to generate the replacement.
              The actual replacement will contain the `cloak_character` where it doesn't cover
              the original text.
              If left empty the legacy behavior of keeping the first character is retained.
            '';
          };
        })
        [
          {

            file_pattern = ".env*";
            cloak_pattern = "=.+";
            replace = null;
          }
        ]
        ''
          List of pattern configurations.
        '';
  };

  settingsExample = {
    enabled = true;
    cloak_character = "*";
    highlight_group = "Comment";
    patterns = [
      {
        file_pattern = [
          ".env*"
          "wrangler.toml"
          ".dev.vars"
        ];
        cloak_pattern = "=.+";
      }
    ];
  };
}
