{ lib, ... }:
let
  inherit (lib) types;

  pathsToLink = [
    # :h rtp
    # TODO: "/filetype.lua" # filetypes (:h new-filetype)
    "/autoload" # automatically loaded scripts (:h autoload-functions)
    "/colors" # color scheme files (:h :colorscheme)
    "/compiler" # compiler files (:h :compiler)
    "/doc" # documentation (:h write-local-help)
    "/ftplugin" # filetype plugins (:h write-filetype-plugin)
    "/indent" # indent scripts (:h indent-expression)
    "/keymap" # key mapping files (:h mbyte-keymap)
    "/lang" # menu translations (:h :menutrans)
    "/lsp" # LSP client configurations (:h lsp-config)
    "/lua" # Lua plugins (:h lua)
    # TODO: "/menu.vim" # GUI menus (:h menu.vim)
    "/pack" # packages (:h :packadd)
    "/parser" # treesitter syntax parsers (:h treesitter)
    "/plugin" # plugin scripts (:h write-plugin)
    "/queries" # treesitter queries (:h treesitter)
    "/rplugin" # remote-plugin scripts (:h remote-plugin)
    "/spell" # spell checking files (:h spell)
    "/syntax" # syntax files (:h mysyntaxfile)
    "/tutor" # tutorial files (:h :Tutor)

    # after
    "/after"

    # ftdetect
    "/ftdetect"

    # plenary.nvim
    "/data/plenary/filetypes"
  ];
in
{
  options.performance = {
    byteCompileLua = {
      enable = lib.mkEnableOption "byte compiling of lua files";
      initLua = lib.mkOption {
        description = "Whether to byte compile init.lua.";
        type = types.bool;
        default = true;
        example = false;
      };
      configs = lib.mkOption {
        description = "Whether to byte compile lua configuration files.";
        type = types.bool;
        default = true;
        example = false;
      };
      plugins = lib.mkEnableOption "plugins" // {
        description = "Whether to byte compile lua plugins.";
      };
      nvimRuntime = lib.mkEnableOption "nvimRuntime" // {
        description = "Whether to byte compile lua files in Nvim runtime.";
      };
      luaLib = lib.mkEnableOption "luaLib" // {
        description = "Whether to byte compile lua library.";
      };
      excludedPlugins = lib.mkOption {
        type = with types; listOf (either str package);
        default = [ ];
        example = lib.literalExpression ''
          [
            "faster.nvim"
             pkgs.vimPlugins.conform-nvim
          ];
        '';
        description = "List of plugins (names or packages) to exclude from byte compilation.";
      };
    };

    combinePlugins = {
      enable = lib.mkEnableOption "combinePlugins" // {
        description = ''
          Whether to enable EXPERIMENTAL option to combine all plugins
          into a single plugin pack. It can significantly reduce startup time,
          but all your plugins must have unique filenames and doc tags.
          Any collision will result in a build failure. To avoid collisions
          you can add your plugin to the `standalonePlugins` option.
          Only standard neovim runtime directories are linked to the combined plugin.
          If some of your plugins contain important files outside of standard
          directories, add these paths to `pathsToLink` option.
        '';
      };
      pathsToLink = lib.mkOption {
        type = with types; listOf str;
        default = [ ];
        # We set this default below in `config` because we want to use default priority
        defaultText = pathsToLink;
        example = [ "/data" ];
        description = "List of paths to link into a combined plugin pack.";
      };
      standalonePlugins = lib.mkOption {
        type = with types; listOf (either str package);
        default = [ ];
        example = [ "nvim-treesitter" ];
        description = "List of plugins (names or packages) to exclude from plugin pack.";
      };
    };
  };

  # Set option value with default priority so that values are appended by default
  config.performance.combinePlugins = { inherit pathsToLink; };
}
