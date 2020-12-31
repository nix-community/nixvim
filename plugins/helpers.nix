{ lib, ... }:
{
  # vim dictionaries are, in theory, compatible with JSON
  toVimDict = args: builtins.toJSON 
    (lib.filterAttrs (n: v: !builtins.isNull v) args);
}
