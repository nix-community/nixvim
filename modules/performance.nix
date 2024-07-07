{ lib, ... }:
let
  inherit (lib) types;
in
{
  options.performance = {
    combinePlugins = {
      enable = lib.mkEnableOption "combinePlugins" // {
        description = ''
          Whether to enable EXPERIMENTAL option to combine all plugins
          into a single plugin pack. It can significantly reduce startup time,
          but all your plugins must have unique filenames and doc tags.
          Any collision will result in a build failure.
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
    ];
  };
}
