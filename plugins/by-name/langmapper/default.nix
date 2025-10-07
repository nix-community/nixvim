{
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    stringToCharacters
    types
    ;
  inherit (lib.nixvim.lua) toLua;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "langmapper";
  package = "langmapper-nvim";
  description = "A plugin that makes Neovim more friendly to non-English input methods";

  maintainers = [ lib.maintainers.shved ];

  settingsExample = {
    automapping_modes = stringToCharacters "invxs";
    map_add_ctrl = false;
  };
  extraOptions = {
    automapping = {
      enable = mkEnableOption "calling `automapping` at the end of `init.lua`" // {
        default = true;
      };
      argument = mkOption {
        description = "An argument to `automapping` call";
        type = with types; either rawLua (attrsOf anything);
        default = {
          global = true;
          buffer = false;
        };
      };
    };
  };
  extraConfig = cfg: {
    # The plugin documentation says that if we need to handle built-in and vim
    # script mappings, we should call this at the very end of `init.lua`. On the
    # other hand it says that we have to call `setup` at the very beginning of
    # plugin list initialisation. But I believe that this is enough to call this
    # at very end of `init.lua` to cover the issues produced by calling `setup`
    # of this plugin at the middle of plugins list
    extraConfigLuaPost = mkIf cfg.automapping.enable ''
      require("langmapper").automapping(${toLua cfg.automapping.argument})
    '';
  };
}
