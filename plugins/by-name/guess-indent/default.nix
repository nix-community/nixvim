{
  lib,
  helpers,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "guess-indent";
  originalName = "guess-indent.nvim";
  package = "guess-indent-nvim";

  maintainers = [ lib.maintainers.GGORG ];

  settingsOptions = {
    auto_cmd = helpers.defaultNullOpts.mkBool true ''
      Whether to create autocommand to automatically detect indentation
    '';

    override_editorconfig = helpers.defaultNullOpts.mkBool false ''
      Whether or not to override indentation set by Editorconfig
    '';

    filetype_exclude =
      helpers.defaultNullOpts.mkListOf types.str
        [
          "netrw"
          "tutor"
        ]
        ''
          Filetypes to ignore indentation detection in
        '';

    buftype_exclude =
      helpers.defaultNullOpts.mkListOf types.str
        [
          "help"
          "nofile"
          "terminal"
          "prompt"
        ]
        ''
          Buffer types to ignore indentation detection in
        '';

    on_tab_options = helpers.defaultNullOpts.mkAttrsOf types.anything { expandtab = false; } ''
      A table of vim options when tabs are detected
    '';

    on_space_options =
      helpers.defaultNullOpts.mkAttrsOf types.anything
        {
          expandtab = true;
          tabstop = "detected";
          softtabstop = "detected";
          shiftwidth = "detected";
        }
        ''
          A table of vim options when spaces are detected
        '';
  };

  settingsExample = {
    auto_cmd = false;
    override_editorconfig = true;
    filetype_exclude = [ "markdown" ];
  };
}
