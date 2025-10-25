{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "jupytext";
  package = "jupytext-nvim";
  description = "Jupyter notebooks on Neovim powered by Jupytext.";

  maintainers = [ lib.maintainers.GaetanLepage ];

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

  dependencies = [ "jupytext" ];

  inherit (import ./deprecations.nix lib) imports;
}
