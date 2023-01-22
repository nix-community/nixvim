{ lib, ... }:
with lib;

rec {
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

  mkRenamedOption =
    { option
    , newOption
    , visible ? false
    , warn ? true
    , overrideDescription ? null
    }:
    { options, ... }:
    let
      fromOpt = getAttrFromPath option options;
      toOf = attrByPath newOption
        (abort "Renaming error: option `${showOption newOption}` does not exist.");
      toType = let opt = attrByPath newOption { } options; in
        opt.type or (types.submodule { });
      message = "`${showOption option}` has been renamed to `${showOption newOption}`, but can still be used for compatibility";
    in
    {
      options = setAttrByPath option (mkOption
        {
          inherit visible;
          description =
            if overrideDescription == null
            then message
            else overrideDescription;
        } // optionalAttrs (toType != null) {
        type = toType;
      });
      config = mkMerge [
        {
          warnings = mkIf (warn) [ "Nixvim: ${message}" ];
        }
        (mkAliasAndWrapDefinitions (setAttrByPath newOption) fromOpt)
      ];
    };

  mkAliasOption = option: newOption: mkRenamedOption {
    inherit option newOption;
    visible = true;
    warn = false;
    overrideDescription = "Alias of ${showOption newOption}";
  };

  # TODO:
  # mkRemovedOption =
  #   { option
  #   , visible ? false
  #   }:
  #   { options, ... }:
  #   {
  #     options = { };
  #     config = { };
  #   };
}
