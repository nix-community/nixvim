{
  lib,
  helpers,
  pkgs,
  config,
  ...
}:
let
  builders = lib.nixvim.builders.withPkgs pkgs;

  fileTypeModule =
    {
      name,
      config,
      options,
      topConfig,
      ...
    }:
    {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether this file should be generated.
            This option allows specific files to be disabled.
          '';
        };

        target = lib.mkOption {
          type = lib.types.str;
          defaultText = lib.literalMD "the attribute name";
          description = ''
            Name of symlink, relative to nvim config.
          '';
        };

        text = lib.mkOption {
          type = with lib.types; nullOr lines;
          default = null;
          description = "Text of the file.";
        };

        source = lib.mkOption {
          type = lib.types.path;
          description = "Path of the source file.";
        };

        finalSource = lib.mkOption {
          type = lib.types.path;
          description = "Path to the final source file.";
          readOnly = true;
          visible = false;
          internal = true;
        };
      };

      config =
        let
          derivationName = "nvim-" + lib.replaceStrings [ "/" ] [ "-" ] name;
        in
        {
          target = lib.mkDefault name;
          source = lib.mkIf (config.text != null) (
            # mkDerivedConfig uses the option's priority, and calls our function with the option's value.
            # This means our `source` definition has the same priority as `text`.
            lib.mkDerivedConfig options.text (pkgs.writeText derivationName)
          );
          finalSource =
            # Byte compile lua files if performance.byteCompileLua option is enabled
            if
              lib.hasSuffix ".lua" config.target
              && topConfig.performance.byteCompileLua.enable
              && topConfig.performance.byteCompileLua.configs
            then
              if lib.isDerivation config.source then
                # Source is a derivation
                builders.byteCompileLuaDrv config.source
              else
                # Source is a path or string
                builders.byteCompileLuaFile derivationName config.source
            else
              config.source;
        };
    };

  fileType = lib.types.submoduleWith {
    shorthandOnlyDefinesConfig = true;
    modules = [ fileTypeModule ];
    specialArgs.topConfig = config;
  };

  # TODO: Added 2024-07-07, remove after 24.11
  # Before we had a fileType, we used types.str.
  coercedFileType = helpers.transitionType lib.types.str (text: { inherit text; }) fileType;
in
{
  options = {
    extraFiles = lib.mkOption {
      type = lib.types.attrsOf coercedFileType;
      description = "Extra files to add to the runtime path";
      default = { };
      example = lib.literalExpression ''
        {
          "after/ftplugin/nix.lua".text = '''
            vim.opt_local.tabstop = 2
            vim.opt_local.shiftwidth = 2
            vim.opt_local.expandtab = true
          ''';
        }
      '';
    };
  };
}
