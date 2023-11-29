{
  config,
  helpers,
  lib,
  pkgs,
  ...
}: {
  options.plugins.debugprint = let
    # https://github.com/NixOS/nixpkgs/blob/055ba65fed8eac15b13ed68f70a7d506f9b2d291/lib/options.nix#L91-L105
    mkEnableOptionInverted = name:
      lib.mkOption {
        default = true;

        description =
          if name ? _type && name._type == "mdDoc"
          then lib.mdDoc "Whether to enable ${name.text}."
          else "Whether to enable ${name}.";

        example = false;
        type = lib.types.bool;
      };

    packageName = "debugprint.nvim";
  in {
    createKeymaps = mkEnableOptionInverted "keymaps";
    displayCounter = mkEnableOptionInverted "display counter";
    displaySnippet = mkEnableOptionInverted "display snippet";

    filetypes = lib.mkOption {
      default = {};

      example = {
        left = ''print "'';
        mid_var = ''''${'';
        right = ''"'';
        right_var = ''}"'';
      };

      description = "Custom filetypes";
      type = lib.types.attrs;
    };

    ignoreTreesitter = lib.mkEnableOption "treesitter";
    moveToDebugline = lib.mkEnableOption "move to debugline";

    printTag = lib.mkOption {
      default = "DEBUGPRINT";
      description = "The string inserted into each print statement, which can be used to uniquely identify statements inserted by `debugprint`.";
      example = "DEBUG";
      type = lib.types.str;
    };

    enable = lib.mkEnableOption packageName;

    package = let
      package = pkgs.vimUtils.buildVimPlugin {
        meta.homepage = "https://github.com/andrewferrier/debugprint.nvim/";
        pname = "debugprint-nvim";

        src = pkgs.fetchFromGitHub {
          owner = "andrewferrier";
          repo = "debugprint.nvim";
          rev = "8a6d66bd6162e9c49804e9286a7d4ceba60355d5";
          sha256 = "sha256-dctYG+ECPuYYNupwycwaE3sdJFi1UK8E+i5057RsfXo=";
        };

        version = "2022-11-29";
      };
    in
      helpers.mkPackageOption packageName package;
  };

  config = let
    cfg = config.plugins.debugprint;
  in
    lib.mkIf cfg.enable {
      extraConfigLua = let
        options = {
          inherit (cfg) filetypes;
          create_keymaps = cfg.createKeymaps;
          display_counter = cfg.displayCounter;
          display_snippet = cfg.displaySnippet;
          ignore_treesitter = cfg.ignoreTreesitter;
          move_to_debugline = cfg.moveToDebugline;
          print_tag = cfg.printTag;
        };
      in ''
        require("debugprint").setup(${helpers.toLuaObject options})
      '';

      extraPlugins = [cfg.package];
    };
}
