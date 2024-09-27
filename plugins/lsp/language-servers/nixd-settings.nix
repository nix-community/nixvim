{ lib, helpers }:
# Options:
#  - https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
#  - https://github.com/nix-community/nixd/blob/main/nixd/include/nixd/Controller/Configuration.h
with lib;
{
  diagnostic = {
    suppress = helpers.defaultNullOpts.mkListOf' {
      type = types.str;
      description = ''
        Disable specific LSP warnings, etc.
        A list of diagnostic _short names_ that should be suppressed.

        See [the source](https://github.com/nix-community/nixd/blob/main/libnixf/include/nixf/Basic/DiagnosticKinds.inc)
        for available diagnostics.
      '';
      pluginDefault = [ ];
      example = [ "sema-escaping-with" ];
    };
  };

  formatting = {
    command = helpers.defaultNullOpts.mkListOf types.str [ "nixpkgs-fmt" ] ''
      Which command you would like to do formatting.
      Explicitly setting to `["nixpkgs-fmt"]` will automatically add `pkgs.nixpkgs-fmt` to the nixvim
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
    helpers.mkNullOrOption (with lib.types; attrsOf (maybeRaw provider)) ''
      Tell the language server your desired option set, for completion.
      This is lazily evaluated.
    '';

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
    helpers.mkNullOrOption (lib.types.maybeRaw provider) ''
      This expression will be interpreted as "nixpkgs" toplevel
      Nixd provides package, lib completion/information from it.
    '';
}
