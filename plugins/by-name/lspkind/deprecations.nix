lib: {
  deprecateExtraOptions = true;
  optionsRenamedToSettings =
    let
      mkOptionPaths = map (lib.splitString ".");
    in
    mkOptionPaths [
      "mode"
      "preset"
      "maxWidth"
      "symbolMap"

      "cmp.maxWidth"
      "cmp.ellipsisChar"
      "cmp.menu"
    ];
}
