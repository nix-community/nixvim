{
  lib,
  pkgs,
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

  inherit (import ./deprecations.nix lib) imports;

  extraOptions = {
    jupytextPackage = lib.mkPackageOption pkgs "jupytext" {
      nullable = true;
      default = [
        "python313Packages"
        "jupytext"
      ];
    };
  };

  extraConfig = cfg: {
    extraPackages = [ cfg.jupytextPackage ];
  };
}
