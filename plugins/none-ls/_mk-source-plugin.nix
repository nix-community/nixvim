# mkSourcePlugin, returns a module
sourceType: sourceName:
{
  config,
  pkgs,
  lib,
  helpers,
  ...
}:
let
  inherit (import ./packages.nix pkgs) packaged;
  pkg = packaged.${sourceName};

  cfg = config.plugins.none-ls;
  cfg' = config.plugins.none-ls.sources.${sourceType}.${sourceName};
in
{
  options.plugins.none-ls.sources.${sourceType}.${sourceName} =
    {
      enable = lib.mkEnableOption "the ${sourceName} ${sourceType} source for none-ls";
      # Support strLua for compatibility with the old withArgs option
      settings = helpers.defaultNullOpts.mkStrLuaOr' {
        type = with lib.types; attrsOf anything;
        description = ''
          Options provided to the `require('null-ls').builtins.${sourceType}.${sourceName}.with` function.

          See upstream's [`BUILTIN_CONFIG`] documentation.

          [`BUILTIN_CONFIG`]: https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
        '';
        example = {
          extra_filetypes = [ "toml" ];
          disabled_filetypes = [ "lua" ];
          extra_args = [
            "-i"
            "2"
            "-ci"
          ];
        };
      };
    }
    # Only declare a package option if a package is required
    // lib.optionalAttrs (packaged ? ${sourceName}) {
      package = lib.mkOption (
        {
          type = lib.types.nullOr lib.types.package;
          description =
            "Package to use for ${sourceName}."
            + (lib.optionalString (pkg == null) (
              "\n\n"
              + ''
                Currently not packaged in nixpkgs.
                Either set this to `null` and install ${sourceName} outside of nix,
                or set this to a custom nix package.
              ''
            ));
        }
        // lib.optionalAttrs (pkg != null) { default = pkg; }
      );
    };

  # TODO: Added 2024-07-16; remove after 24.11
  imports =
    let
      basePath = [
        "plugins"
        "none-ls"
        "sources"
        sourceType
        sourceName
      ];
    in
    [ (lib.mkRenamedOptionModule (basePath ++ [ "withArgs" ]) (basePath ++ [ "settings" ])) ];

  config = lib.mkIf (cfg.enable && cfg'.enable) {
    plugins.none-ls.settings.sources = lib.mkDefault [
      (
        "require('null-ls').builtins.${sourceType}.${sourceName}"
        + lib.optionalString (cfg'.settings != null) ".with(${helpers.toLuaObject cfg'.settings})"
      )
    ];

    extraPackages = [ (cfg'.package or null) ];
  };
}
