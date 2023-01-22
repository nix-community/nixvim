{ lib, ... }:
with lib;

{
  # This should be used instead of mkRemovedOptionModule, when the option still works,
  #   but is just deprecated and should be changed now and for the future
  mkDeprecatedOption =
    { option # an array of the path to the option
    , alternative ? null
    , message ? null
    , visible ? false
    }:
    { options, ... }:
    let
      fromOpt = getAttrFromPath option options;
      fullMessage = "The option `${showOption option}` has been deprecated, but might still work." +
        (optionalString (alternative != null) " You may want to use `${showOption alternative}` instead.") +
        (optionalString (message != null) " Message: ${message}");
    in
    {
      config = mkIf (fromOpt.isDefined) {
        warnings = [
          ("Nixvim: ${fullMessage}")
        ];
      };
    };

  # For removed options, we can just use nixpkgs mkRemovedOptionModule, which is already in lib
  mkRemovedOption = mkRemovedOptionModule;

  # For renamed options, we can also use the function from nixpkgs
  mkRenamedOption = mkRenamedOptionModule; # use the function from nixpkgs
}
