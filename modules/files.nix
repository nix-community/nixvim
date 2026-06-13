{
  lib,
  pkgs,
  config,
  ...
}:
let
  builders = lib.nixvim.builders.withPkgs pkgs;
  byteCompileLua = with config.performance.byteCompileLua; enable && configs;

  fileTypeModule =
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
            if byteCompileLua then
              if lib.hasSuffix ".lua" config.target then
                # It is possible to remove this condition entirely and use only
                # `builders.byteCompileLuaFile` for all files, but this way it's
                # slightly faster, because `finalSource` is built directly from
                # `text`, not from intermediate `source`
                if lib.isDerivation config.source && !config.source ? outputHash then
                  # Source is a derivation (not fixed-output)
                  builders.byteCompileLuaDrv config.source
                else
                  # Source is a path, string or fixed-output derivation
                  builders.byteCompileLuaFile derivationName config.source
              else if
                builtins.isPath config.source
                && lib.filesystem.pathIsDirectory config.source
                && builtins.any (lib.hasSuffix ".lua") (lib.filesystem.listFilesRecursive config.source)
              then
                # Source is a directory path with lua files
                builders.byteCompileLuaDrv (
                  pkgs.stdenvNoCC.mkDerivation {
                    name = derivationName;
                    src = config.source;
                    phases = "unpackPhase installPhase fixupPhase";
                    installPhase = "cp -R ./ $out";
                  }
                )
              else
                config.source
            else
              config.source;
        };
    };
in
{
  options = {
    extraFiles = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule fileTypeModule);
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
