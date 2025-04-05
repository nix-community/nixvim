{ lib, ... }:
let
  inherit (lib) types;
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

  config.performance = {
    # Set option value with default priority so that values are appended by default
    combinePlugins.pathsToLink = [
      # :h rtp
      "/autoload"
      "/colors"
      "/compiler"
      "/doc"
      "/ftplugin"
      "/indent"
      "/keymap"
      "/lang"
      "/lua"
      "/pack"
      "/parser"
      "/plugin"
      "/queries"
      "/rplugin"
      "/spell"
      "/syntax"
      "/tutor"
      "/after"
      # ftdetect
      "/ftdetect"
      # plenary.nvim
      "/data/plenary/filetypes"
    ];
  };
}
