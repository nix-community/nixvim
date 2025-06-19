{
  lib,
  helpers,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "sleuth";
  packPathName = "vim-sleuth";
  package = "vim-sleuth";
  globalPrefix = "sleuth_";
  description = "This plugin automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    heuristics = helpers.defaultNullOpts.mkFlagInt 1 ''
      Whether to enable/disable heuristics by default.

      You can also disable heuristics for individual filetypes:
      ```nix
        settings = {
          heuristics = 1;
          gitcommit_heuristics = 0;
        };
      ```
    '';

    no_filetype_indent_on = helpers.defaultNullOpts.mkFlagInt 0 ''
      Sleuth forces `|:filetype-indent-on|` by default, which enables file-type specific indenting
      algorithms and is highly recommended.
    '';
  };

  settingsExample = {
    heuristics = 1;
    gitcommit_heuristics = 0;
    no_filetype_indent_on = 1;
  };
}
