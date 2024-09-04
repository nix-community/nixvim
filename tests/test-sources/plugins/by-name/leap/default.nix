{
  empty = {
    plugins.leap.enable = true;
  };

  # https://github.com/nix-community/nixvim/issues/1698
  autojump-disabled = {
    plugins.leap = {
      enable = true;

      safeLabels.__empty = null;
    };
  };

  example = {
    plugins.leap = {
      enable = true;

      addDefaultMappings = true;
      maxPhaseOneTargets = 10;
      highlightUnlabeledPhaseOneTargets = false;
      maxHighlightedTraversalTargets = 10;
      caseSensitive = false;
      equivalenceClasses = [ " \t\r\n" ];
      substituteChars = {
        "\r" = "¬";
      };
      safeLabels = [
        "s"
        "f"
        "n"
        "u"
        "t"
        "/"
        "S"
        "F"
        "N"
        "L"
        "H"
        "M"
        "U"
        "G"
        "T"
        "?"
        "Z"
      ];
      labels = [
        "s"
        "f"
        "n"
        "j"
        "k"
        "l"
        "h"
        "o"
        "d"
        "w"
        "e"
        "m"
        "b"
        "u"
        "y"
        "v"
        "r"
        "g"
        "t"
        "c"
        "x"
        "/"
        "z"
        "S"
        "F"
        "N"
        "J"
        "K"
        "L"
        "H"
        "O"
        "D"
        "W"
        "E"
        "M"
        "B"
        "U"
        "Y"
        "V"
        "R"
        "G"
        "T"
        "C"
        "X"
        "?"
        "Z"
      ];
      specialKeys = {
        nextTarget = "<enter>";
        prevTarget = "<tab>";
        nextGroup = "<space>";
        prevGroup = "<tab>";
        multiAccept = "<enter>";
        multiRevert = "<backspace>";
      };
    };
  };
}
