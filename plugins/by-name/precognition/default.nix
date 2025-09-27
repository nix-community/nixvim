{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "precognition";
  package = "precognition-nvim";
  description = "Precognition uses virtual text and gutter signs to show available motions.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    startVisible = defaultNullOpts.mkBool true ''
      Whether to show precognition.nvim on startup.
    '';

    showBlankVirtLine = defaultNullOpts.mkBool true ''
      Setting this option will mean that if a Virtual Line would be blank it won't be rendered.
    '';

    disabled_fts = defaultNullOpts.mkListOf types.str [
      "startify"
    ] "`precognition.nvim` is disabled under these filetypes.";

    highlightColor =
      defaultNullOpts.mkAttrsOf types.anything
        {
          link = "Comment";
        }
        ''
          Highlight groups for the hints.

          Can be defined as either:
          -  As a table containing a link property pointing to an existing highlight group.
          -  As a table specifying custom highlight values, such as foreground and background colors.
        '';

    hints =
      defaultNullOpts.mkAttrsOf types.anything
        {
          Caret = {
            text = "^";
            prio = 2;
          };
          Dollar = {
            text = "$";
            prio = 1;
          };
          MatchingPair = {
            text = "%";
            prio = 5;
          };
          Zero = {
            text = "0";
            prio = 1;
          };
          w = {
            text = "w";
            prio = 10;
          };
          b = {
            text = "b";
            prio = 9;
          };
          e = {
            text = "e";
            prio = 8;
          };
          W = {
            text = "W";
            prio = 7;
          };
          B = {
            text = "B";
            prio = 6;
          };
          E = {
            text = "E";
            prio = 5;
          };
        }
        ''
          Hints that will be shown on the virtual line.
          Priority is used to determine which hint to show when two can be shown at the same spot.

          Hints can be hidden by setting their priority to `0`.
          If you want to hide the entire virtual line, set all elements to `prio = 0`.
        '';

    gutterHints =
      defaultNullOpts.mkAttrsOf types.anything
        {
          G = {
            text = "G";
            prio = 10;
          };
          gg = {
            text = "gg";
            prio = 9;
          };
          PrevParagraph = {
            text = "{";
            prio = 8;
          };
          NextParagraph = {
            text = "}";
            prio = 8;
          };
        }
        ''
          Hints that will be shown on the gutter.

          Hints can be hidden by setting their priority to `0`.
        '';
  };

  settingsExample = {
    startVisible = false;
    showBlankVirtLine = false;
    highlightColor = {
      link = "Text";
    };
    disabled_fts = [
      "startify"
      "dashboard"
    ];
  };
}
