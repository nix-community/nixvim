{
  lib,
  helpers,
  config,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "headlines";
  packPathName = "headlines.nvim";
  package = "headlines-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  settingsExample = {
    org.headline_highlights = false;
    norg = {
      headline_highlights = [ "Headline" ];
      codeblock_highlight = false;
    };
    markdown.headline_highlights = [ "Headline1" ];
  };

  extraConfig = {
    warnings = lib.nixvim.mkWarnings "plugins.headlines" {
      when = !config.plugins.treesitter.enable;

      message = ''
        headlines requires `plugins.treesitter` to be enabled with the relevant grammars installed.
      '';
    };
  };
}
