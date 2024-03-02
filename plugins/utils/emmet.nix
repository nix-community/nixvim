{
  lib,
  config,
  helpers,
  pkgs,
  ...
}:
with lib;
with helpers.vim-plugin;
  mkVimPlugin config {
    name = "emmet";
    originalName = "emmet-vim";
    defaultPackage = pkgs.vimPlugins.emmet-vim;
    globalPrefix = "user_emmet_";

    # TODO introduced 2024-03-01: remove 2024-05-01
    deprecateExtraConfig = true;
    optionsRenamedToSettings = [
      "mode"
    ];
    imports = [
      (
        mkRenamedOptionModule
        ["plugins" "emmet" "leader"]
        ["plugins" "emmet" "settings" "leader_key"]
      )
    ];

    settingsOptions = {
      mode = helpers.defaultNullOpts.mkStr "a" ''
        Choose modes, in which Emmet mappings will be created.
        Default value: 'a' - all modes.
        - 'n' - normal mode.
        - 'i' - insert mode.
        - 'v' - visual mode.

        Examples:
        - create Emmet mappings only for normal mode: `n`
        - create Emmet mappings for insert, normal and visual modes: `inv`
        - create Emmet mappings for all modes: `a`
      '';

      leader_key = helpers.defaultNullOpts.mkStr "<C-y>" ''
        Leading keys to run Emmet functions.
      '';

      settings = helpers.mkNullOrOption (with types; attrsOf anything) ''
        Emmet settings.

        Defaults: see https://github.com/mattn/emmet-vim/blob/master/autoload/emmet.vim
      '';
    };

    settingsExample = {
      mode = "inv";
      leader = "<C-Z>";
      settings = {
        variables = {
          lang = "ja";
        };
        html = {
          default_attributes = {
            option = {value = null;};
            textarea = {
              id = null;
              name = null;
              cols = 10;
              rows = 10;
            };
          };
          snippets = {
            "html:5" = ''
              <!DOCTYPE html>
              <html lang=\"$\{lang}\">
              <head>
              \t<meta charset=\"$\{charset}\">
              \t<title></title>
              \t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
              </head>
              <body>\n\t$\{child}|\n</body>
              </html>
            '';
          };
        };
      };
    };
  }
