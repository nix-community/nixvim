{ lib, ... }:
# Options:
#  - https://github.com/grafana/jsonnet-language-server/tree/main/editor/vim
#  - https://github.com/grafana/jsonnet-language-server/blob/main/pkg/server/configuration.go
#  - https://github.com/google/go-jsonnet/blob/master/internal/formatter/jsonnetfmt.go#L55
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
{
  ext_vars = defaultNullOpts.mkAttrsOf types.str { } ''
    External variables.
  '';

  formatting = {
    Indent = defaultNullOpts.mkUnsignedInt 2 ''
      The number of spaces for each level of indentation.
    '';

    MaxBlankLines = defaultNullOpts.mkUnsignedInt 2 ''
      Max allowed number of consecutive blank lines.
    '';

    StringStyle =
      defaultNullOpts.mkEnum
        [
          "double"
          "single"
          "leave"
        ]
        "single"
        ''
          Whether strings should use double quotes `"`, single quotes `'`, or be left as-is.
        '';

    CommentStyle =
      defaultNullOpts.mkEnum
        [
          "hash"
          "slash"
          "leave"
        ]
        "slash"
        ''
          Whether comments should use hash `#`, slash `//`, or be left as-is.
        '';

    PrettyFieldNames = defaultNullOpts.mkBool true ''
      Causes fields to only be wrapped in `'''` when needed.
    '';

    PadArrays = defaultNullOpts.mkBool false ''
      Causes arrays to be written like `[ this ]` instead of `[this]`.
    '';

    PadObjects = defaultNullOpts.mkBool true ''
      Causes objects to be written like `{ this }` instead of `{this}`.
    '';

    SortImports = defaultNullOpts.mkBool true ''
      Causes imports at the top of the file to be sorted in groups by filename.
    '';

    UseImplicitPlus = defaultNullOpts.mkBool true ''
      Removes plus sign where it is not required.
    '';

    StripEverything = defaultNullOpts.mkBool false ''
      Removes all comments and newlines.
    '';

    StripComments = defaultNullOpts.mkBool false ''
      Removes all comments.
    '';

    StripAllButComments = defaultNullOpts.mkBool false ''
      Removes everything, other than comments.
    '';
  };
}
