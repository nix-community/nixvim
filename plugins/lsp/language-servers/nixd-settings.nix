{ lib, helpers }:
# Options:
#  - https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
#  - https://github.com/nix-community/nixd/blob/main/nixd/include/nixd/Controller/Configuration.h
with lib;
{
  formatting = {
    command = helpers.defaultNullOpts.mkListOf types.str [ "nixpkgs-fmt" ] ''
      Which command you would like to do formatting.
      Explicitly set to `["nixpkgs-fmt"]` will automatically add `pkgs.nixpkgs-fmt` to the nixvim
      environment.
    '';
  };

  options =
    let
      provider = types.submodule {
        options = {
          expr = mkOption {
            type = types.str;
            description = "Expression to eval. Select this attrset as eval .options";
          };
        };
      };
    in
    helpers.defaultNullOpts.mkAttrsOf' {
      type = provider;
      description = ''
        Tell the language server your desired option set, for completion.
        This is lazily evaluated.
      '';
    };

  nixpkgs =
    let
      provider = types.submodule {
        options = {
          expr = mkOption {
            type = types.str;
            description = "Expression to eval. Treat it as `import <nixpkgs> { }`";
          };
        };
      };
    in
    helpers.defaultNullOpts.mkNullableWithRaw' {
      type = provider;
      description = ''
        This expression will be interpreted as "nixpkgs" toplevel
        Nixd provides package, lib completion/information from it.
      '';
    };
}
