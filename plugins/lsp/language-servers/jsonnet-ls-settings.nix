{ lib, helpers }:
# Options:
#  - https://github.com/grafana/jsonnet-language-server/tree/main/editor/vim
#  - https://github.com/grafana/jsonnet-language-server/blob/main/pkg/server/configuration.go
#  - https://github.com/google/go-jsonnet/blob/master/internal/formatter/jsonnetfmt.go#L55
with lib;
{
  ext_vars = helpers.defaultNullOpts.mkAttrsOf types.str { } ''
    External variables.
  '';

  formatting = {
    Indent = helpers.defaultNullOpts.mkUnsignedInt 2 ''
      The number of spaces for each level of indenation.
    '';

    MaxBlankLines = helpers.defaultNullOpts.mkUnsignedInt 2 ''
      Max allowed number of consecutive blank lines.
    '';

    StringStyle =
      helpers.defaultNullOpts.mkEnum
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
      helpers.defaultNullOpts.mkEnum
        [
          "hash"
          "slash"
          "leave"
        ]
        "slash"
        ''
          Whether comments should use hash `#`, slash `//`, or be left as-is.
        '';

    PrettyFieldNames = helpers.defaultNullOpts.mkBool true ''
      Causes fields to only be wrapped in `'''` when needed.
    '';

    PadArrays = helpers.defaultNullOpts.mkBool false ''
      Causes arrays to be written like `[ this ]` instead of `[this]`.
    '';

    PadObjects = helpers.defaultNullOpts.mkBool true ''
      Causes objects to be written like `{ this }` instead of `{this}`.
    '';

    SortImports = helpers.defaultNullOpts.mkBool true ''
      Causes imports at the top of the file to be sorted in groups by filename.
    '';

    UseImplicitPlus = helpers.defaultNullOpts.mkBool true ''
      Removes plus sign where it is not required.
    '';

    StripEverything = helpers.defaultNullOpts.mkBool false ''
      Removes all comments and newlines.
    '';

    StripComments = helpers.defaultNullOpts.mkBool false ''
      Removes all comments.
    '';

    StripAllButComments = helpers.defaultNullOpts.mkBool false ''
      Removes everything, other than comments.
    '';
  };
}
