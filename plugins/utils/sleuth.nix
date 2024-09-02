{
  lib,
  helpers,
  ...
}:
helpers.vim-plugin.mkVimPlugin {
  name = "sleuth";
  originalName = "vim-sleuth";
  package = "vim-sleuth";
  globalPrefix = "sleuth_";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    heuristics = helpers.defaultNullOpts.mkBool true ''
      Whether to enable/disable heuristics by default.

      You can also disable heuristics for individual filetypes:
      ```nix
        settings = {
          heuristics = true;
          gitcommit_heuristics = false;
        };
      ```
    '';

    no_filetype_indent_on = helpers.defaultNullOpts.mkBool false ''
      Sleuth forces `|:filetype-indent-on|` by default, which enables file-type specific indenting
      algorithms and is highly recommended.
    '';
  };

  settingsExample = {
    heuristics = true;
    gitcommit_heuristics = false;
    no_filetype_indent_on = true;
  };
}
