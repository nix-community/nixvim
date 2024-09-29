{
  empty = {
    plugins.web-devicons.enable = true;
  };

  custom-icons = {
    plugins.web-devicons = {
      enable = true;

      customIcons = {
        lir_folder_icon = {
          icon = "";
          color = "#7ebae4";
          name = "LirFolderNode";
        };
        zsh = {
          icon = "";
          color = "#428850";
          cterm_color = "65";
          name = "Zsh";
        };
      };
    };
  };

  default-icon = {
    plugins.web-devicons = {
      enable = true;

      defaultIcon = {
        icon = "";
        color = "#7ebae4";
        cterm_color = "65";
      };
    };
  };

  default-icon-no-color = {
    plugins.web-devicons = {
      enable = true;

      defaultIcon = {
        icon = "";
      };
    };
  };
}
