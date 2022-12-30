{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.plugins.magma-nvim;
  plugins = import ../plugin-defs.nix { inherit pkgs; };
  package = pkgs.fetchFromGitHub {
      owner = "dccsillag";
      repo = "magma-nvim";
      rev = version;
      sha256 = "sha256-IaslJK1F2BxTvZzKGH9OKOl2RICi4d4rSgjliAIAqK4=";
    };
in {
  options = {
    plugins.magma-nvim = {
      enable = mkEnableOption "Enable magma-nvim?";
      image_provider = mkOption {
        type = types.enum [ "none" "ueberzug" "kitty" ];
        default = "none";
        example = "ueberzug";
        description =
          " This configures how to display images. The following options are available:
          none -- don't show imagesmagma_image_provider.
          ueberzug -- use Ueberzug to display images.
          kitty -- use the Kitty protocol to display images.";
      };
      automatically_open_output = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description =
          " If this is true, then whenever you have an active cell its output window will be automatically shown.
          If this is false, then the output window will only be automatically shown when you've just evaluated the code. So, if you take your cursor out of the cell, and then come back, the output window won't be opened (but the cell will be highlighted). This means that there will be nothing covering your code. You can then open the output window at will using :MagmaShowOutput.";
      };

      wrap_output = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description =
          " If this is true, then text output in the output window will be wrapped (akin to set wrap).";
      };

      output_window_borders = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description =
          " If this is true, then the output window will have rounded borders. If it is false, it will have no borders.";
      };

      cell_highlight_group = mkOption {
        type = types.str;
        default = "CursorLine";
        # example = "";
        description =
          " The highlight group to be used for highlighting cells.";
      };
      save_path = mkOption {
        type = types.nullOr types.str;
        default = null;
        description =
          "Where to save/load with :MagmaSave and :MagmaLoad (with no parameters).
          The generated file is placed in this directory, with the filename itself being the buffer's name, with % replaced by %% and / replaced by %, and postfixed with the extension .json.";
      };
      show_mimetype_debug = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description =
          " If this is true, then before any non-iostream output chunk, Magma shows the mimetypes it received for it.
          This is meant for debugging and adding new mimetypes.";
      };
      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        example = 
        "package = pkgs.fetchFromGitHub {
          owner = \"WhiteBlackGoose\";
          repo = \"magma-nvim-goose\";
          rev = version;
          sha256 = \"sha256-IaslJK1F2BxTvZzKGH9OKOl2RICi4d4rSgjliAIAqK4=\";} ";
        

      };

    };
  };
  config = mkIf cfg.enable {
    extraPlugins = [ ( 
      if cfg.package != null then plugins.magma-nvim.override {src = cfg.package;} else plugins.magma-nvim 
    )];


    globals = {
      magma_image_provider =
        mkIf (cfg.image_provider != "none") cfg.image_provider;
      magma_automatically_open_output =
        mkIf (!cfg.automatically_open_output) cfg.automatically_open_output;
      magma_wrap_output = mkIf (!cfg.wrap_output) cfg.wrap_output;
      magma_output_window_borders =
        mkIf (!cfg.output_window_borders) cfg.output_window_borders;
      magma_highlight_group = mkIf (cfg.cell_highlight_group != "CursorLine")
        cfg.cell_highlight_group;
      magma_show_mimetype_debug =
        mkIf cfg.show_mimetype_debug cfg.show_mimetype_debug;

    };
  };

}

