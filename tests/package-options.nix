# This test ensures "package" options use a "literalExpression" in their defaultText
# I.e. it validates `lib.mkPackageOption` was used to build the package options.
{
  nixvimConfiguration,
  lib,
  runCommandNoCCLocal,
}:
let
  inherit (builtins)
    filter
    head
    map
    match
    ;
  inherit (lib.strings) concatMapStringsSep removePrefix removeSuffix;
  inherit (lib.attrsets) isDerivation;
  inherit (lib.options)
    isOption
    renderOptionValue
    showOption
    ;

  # This doesn't collect any submodule sub-options,
  # but that's fine since most of our "package" options are in the top level module eval
  options = lib.collect isOption nixvimConfiguration.options;

  # All visible non-sub options that default to a derivation
  drvOptions = filter (
    {
      default ? null,
      visible ? true,
      internal ? false,
      ...
    }:
    let
      # Some options have defaults that throw when evaluated
      default' = (builtins.tryEval default).value;
    in
    visible && !internal && isDerivation default'
  ) options;

  # Bad options do not use `literalExpression` in their `defaultText`,
  # or have a `defaultText` that doesn't start with "pkgs."
  badOptions = filter (
    opt:
    opt.defaultText._type or null != "literalExpression"
    || match ''pkgs[.].*'' (opt.defaultText.text or "") == null
  ) drvOptions;
in
runCommandNoCCLocal "validate-package-options"
  {
    # Use structuredAttrs to avoid "Argument List Too Long" errors
    # and get proper bash array support.
    __structuredAttrs = true;

    # Passthroughs for debugging purposes
    passthru = {
      inherit nixvimConfiguration drvOptions badOptions;
    };

    # Error strings to print
    errors =
      let
        # A little hack to get the flake's source in the nix store
        # We will use this to make the option declaration sources more readable
        src = removeSuffix "modules/top-level/output.nix" (
          head nixvimConfiguration.options.package.declarations
        );
      in
      map (
        opt:
        let
          # The default, as rendered in documentation. Will always be a literalExpression.
          default = builtins.addErrorContext "while evaluating the default text for `${showOption opt.loc}`" (
            renderOptionValue (opt.defaultText or opt.default)
          );
        in
        ''
          - ${showOption opt.loc} (${default.text}), declared in:
          ${concatMapStringsSep "\n" (file: "  - ${removePrefix src file}") opt.declarations}
        ''
      ) badOptions;
  }
  ''
    if [ -n "$errors" ]; then
      echo "Found ''${#errors[@]} errors:"
      for err in "''${errors[@]}"; do
        echo "$err"
      done
      echo "(''${#errors[@]} options with errors)"
      exit 1
    fi
    touch $out
  ''
