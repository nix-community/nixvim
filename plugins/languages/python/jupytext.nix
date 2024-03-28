{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
  helpers.neovim-plugin.mkNeovimPlugin config {
    name = "jupytext";
    originalName = "jupytext.nvim";
    defaultPackage = pkgs.vimPlugins.jupytext-nvim;

    maintainers = [maintainers.GaetanLepage];

    settingsOptions = {
      style = helpers.defaultNullOpts.mkStr "hydrogen" ''
        The jupytext style to use.
      '';

      output_extension = helpers.defaultNullOpts.mkStr "auto" ''
        By default, the extension of the plain text file is automatically selected by jupytext.
        This can be modified by changing the extension from auto to any other file extension supported
        by Jupytext.
        This is most useful to those using Quarto or Markdown.
        Analogously, we can provide a default filetype that will be given to the new buffer by using
        `force_ft`.
        Again, this is only really useful to users of Quarto.
      '';

      force_ft = helpers.mkNullOrStr ''
        Default filetype. Don't change unless you know what you are doing.
      '';

      custom_language_formatting = helpers.defaultNullOpts.mkAttrsOf types.anything "{}" ''
        By default we use the auto mode of jupytext.
        This will create a script with the correct extension for each language.
        However, this can be overridden in a per language basis if you want to.
        For this you can set this option.

        For example, to convert python files to quarto markdown:
        ```nix
          {
            python = {
              extension = "qmd";
              style = "quarto";
              force_ft = "quarto";
            };
          }
        ```
      '';
    };

    settingsExample = {
      style = "light";
      output_extension = "auto";
      force_ft = null;
      custom_language_formatting = {
        python = {
          extension = "md";
          style = "markdown";
          force_ft = "markdown";
        };
      };
    };
  }
