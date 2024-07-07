{
  lib,
  helpers,
  pkgs,
  ...
}:
let
  fileType = lib.types.submodule (
    {
      name,
      config,
      options,
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
        };
    }
  );

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
          "ftplugin/nix.lua".text = '''
            vim.opt.tabstop = 2
            vim.opt.shiftwidth = 2
            vim.opt.expandtab = true
          ''';
        }
      '';
    };
  };
}
