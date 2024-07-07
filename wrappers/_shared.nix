helpers:
{ lib, config, ... }:
let
  inherit (lib)
    isAttrs
    listToAttrs
    map
    mkOption
    mkOptionType
    ;
  cfg = config.programs.nixvim;
  extraFiles = lib.filter (file: file.enable) (lib.attrValues cfg.extraFiles);
in
{
  helpers = mkOption {
    type = mkOptionType {
      name = "helpers";
      description = "Helpers that can be used when writing nixvim configs";
      check = isAttrs;
    };
    description = "Use this option to access the helpers";
    default = helpers;
  };

  # extraFiles, but nested under "nvim/" for use in etc/xdg config
  configFiles = listToAttrs (
    map (
      { target, source, ... }:
      {
        name = "nvim/" + target;
        value = {
          inherit source;
        };
      }
    ) extraFiles
  );
}
