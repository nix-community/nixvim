{ pkgs, lib, config, ... }:

with lib;

let

  name = "todo-comments";

  helpers = import ../helpers.nix { inherit lib config; };
  cfg = config.programs.nixvim.plugins.${name};

  keywordModule = { name, config, ...}: {
    options = with helpers; {
      icon = strOption " " "Icon used for the sign and in search results";
      color = strOption "error" "Can be a hex color or a named color";
      alt = mkOption {
        type = with types; either str (listOf str);
        description = "A list of other keywords that map to this keyword";
        example = [ "FIXME" "BUG" "FIXIT" "ISSUE" ];
        default = "";
      };
    };
  };

  moduleOptions = with helpers; {
    signs = boolOption true "Show icons in the signs column";
    signPriority = intOption 8 "sign_priority";
    keywords = mkOption {
      type = types.nullOr (types.attrsOf (types.submodule keywordModule));
      description = "Keywords recognized as 'todo' comments";
      default = null;
    };
    mergeKeywords = boolOption true "When true, custom keywords will be merged with the defaults";
  };

  pluginOptions = {
    signs = cfg.signs;
    sign_priority = cfg.signPriority;
    keywords = cfg.keywords;
    merge_keywords = cfg.mergeKeywords;
  };

in with helpers;
mkLuaPlugin {
  inherit name moduleOptions;
  description = "Enable ${name}.nvim";
  extraPlugins = with pkgs.vimExtraPlugins; [ 
    todo-comments-nvim
  ];
  extraConfigLua = "require('${name}').setup ${toLuaObject pluginOptions}";
}
