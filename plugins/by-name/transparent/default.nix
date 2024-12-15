{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "transparent";
  packPathName = "transparent.nvim";
  package = "transparent-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    groups =
      helpers.defaultNullOpts.mkListOf types.str
        [
          "Normal"
          "NormalNC"
          "Comment"
          "Constant"
          "Special"
          "Identifier"
          "Statement"
          "PreProc"
          "Type"
          "Underlined"
          "Todo"
          "String"
          "Function"
          "Conditional"
          "Repeat"
          "Operator"
          "Structure"
          "LineNr"
          "NonText"
          "SignColumn"
          "CursorLine"
          "CursorLineNr"
          "StatusLine"
          "StatusLineNC"
          "EndOfBuffer"
        ]
        ''
          The list of transparent groups.
        '';

    extra_groups = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      Additional groups that should be cleared.
    '';

    exclude_groups = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      Groups that you don't want to clear.
    '';
  };

  settingsExample = {
    extra_groups = [
      "BufferLineTabClose"
      "BufferLineBufferSelected"
      "BufferLineFill"
      "BufferLineBackground"
      "BufferLineSeparator"
      "BufferLineIndicatorSelected"
    ];
    exclude_groups = [ ];
  };
}
