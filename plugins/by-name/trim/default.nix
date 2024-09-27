{
  lib,
  helpers,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "trim";
  originalName = "trim.nvim";
  package = "trim-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    ft_blocklist = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      Filetypes to exclude.
    '';

    patterns = mkOption {
      type = with lib.types; listOf strLua;
      apply = map helpers.mkRaw;
      default = [ ];
      example = [ "[[%s/\(\n\n\)\n\+/\1/]]" ];
      description = ''
        Extra patterns to use for removing white spaces.

        Plugin default: `[]`
      '';
    };

    trim_on_write = helpers.defaultNullOpts.mkBool true ''
      Whether to automatically trim on write.
    '';

    trim_trailing = helpers.defaultNullOpts.mkBool true ''
      Whether to trim trailing whitespaces.
    '';

    trim_last_line = helpers.defaultNullOpts.mkBool true ''
      Whether to trim trailing blank lines at the end of the file.
    '';

    trim_first_line = helpers.defaultNullOpts.mkBool true ''
      Whether to trim blank lines at the beginning of the file.
    '';

    highlight = helpers.defaultNullOpts.mkBool false ''
      Whether to highlight trailing whitespaces.
    '';

    highlight_bg = helpers.defaultNullOpts.mkStr "#ff0000" ''
      Which color to use for coloring whitespaces.
    '';

    highlight_ctermbg = helpers.defaultNullOpts.mkStr "red" ''
      Which color to use for coloring whitespaces (cterm).
    '';
  };

  settingsExample = {
    ft_blocklist = [ "markdown" ];
    patterns = [ "[[%s/\(\n\n\)\n\+/\1/]]" ];
    trim_on_write = false;
    highlight = true;
  };
}
