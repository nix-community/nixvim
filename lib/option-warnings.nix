{ lib, ... }:
with lib;

rec {
  mkDeprecatedOption =
    { option # an array of the path to the option
    , alternative ? null
    , message ? null
    , visible ? false
    , ...
    }:
    { options, ... }:
    let
      fromOpt = getAttrFromPath option options;
      fullMessage = "The option `${showOption option}` has been deprecated." +
        (optionalString (alternative != null) " You may want to use `${showOption alternative}` instead.") +
        (optionalString (message != null) " Message: ${message}");
    in
    {
      options = setAttrByPath option
        (mkOption {
          inherit visible;
          description = fullMessage;
        });
      config = mkIf (fromOpt.isDefined) {
        warnings = [
          ("Nixvim: ${fullMessage}")
        ];
      };
    };
}
