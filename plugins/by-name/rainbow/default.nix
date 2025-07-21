{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "rainbow";
  package = "rainbow";
  description = "Rainbow parentheses improved — shorter code, no level limit, smooth and fast with powerful configuration.";
  maintainers = [ lib.maintainers.saygo-png ];
  globalPrefix = "rainbow_";

  settingsExample = {
    active = 1;
    conf = {
      guifgs = [
        "#7d8618"
        "darkorange3"
        "seagreen3"
        "firebrick"
      ];
      operators = "_,_";
      parentheses = [
        "start=/(/ end=/)/ fold"
        "start=/\\[/ end=/\\]/ fold"
      ];
      separately = {
        "*" = { };
        markdown = {
          parentheses_options = "containedin=markdownCode contained";
        };
        haskell = {
          parentheses = [
            "start=/\\[/ end=/\\]/ fold"
            "start=/\v\{\ze[^-]/ end=/}/ fold"
          ];
        };
        css = 0;
      };
    };
  };
}
