{ lib, ... }:
let
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "transparent";
  package = "transparent-nvim";
  description = "Remove all background colors to make Neovim transparent.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    groups =
      lib.nixvim.defaultNullOpts.mkListOf types.str
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

    extra_groups = lib.nixvim.defaultNullOpts.mkListOf types.str [ ] ''
      Additional groups that should be cleared.
    '';

    exclude_groups = lib.nixvim.defaultNullOpts.mkListOf types.str [ ] ''
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
