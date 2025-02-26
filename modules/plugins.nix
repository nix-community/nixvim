{ lib, options, ... }:
let
  inherit (builtins) readDir;
  inherit (lib.attrsets) foldlAttrs mapAttrs';
  inherit (lib.lists) optional;
  by-name = ../plugins/by-name;
in
{
  imports =
    [ ../plugins ]
    ++ foldlAttrs (
      prev: name: type:
      prev ++ optional (type == "directory") (by-name + "/${name}")
    ) [ ] (readDir by-name);

  docs.optionPages =
    let
      mkPluginPages =
        scope:
        mapAttrs' (
          name: _:
          let
            loc = [
              scope
              name
            ];
          in
          {
            name = lib.concatStringsSep "/" loc;
            value = {
              optionScopes = loc;
            };
          }
        ) options.${scope};
    in
    {
      colorschemes = {
        enable = true;
        optionScopes = [ "colorschemes" ];
      };
      plugins = {
        enable = true;
        optionScopes = [ "plugins" ];
      };
    }
    // mkPluginPages "plugins"
    // mkPluginPages "colorschemes";
}
