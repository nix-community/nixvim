{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (config.docs._utils)
    docsPageModule
    ;

  docsPageType = lib.types.submodule (
    {
      name,
      config,
      options,
      ...
    }:
    let
      derivationName = builtins.replaceStrings [ "/" ] [ "-" ] name;
    in
    {
      imports = [
        docsPageModule
      ];
      options.text = lib.mkOption {
        type = with lib.types; nullOr lines;
        default = null;
        description = "Text of the file.";
      };
      config.source = lib.mkIf (config.text != null) (
        lib.mkDerivedConfig options.text (builtins.toFile derivationName)
      );
    }
  );

  user-guide = ../../docs/user-guide;

  sourceTransformers = {
    config-examples =
      template:
      pkgs.callPackage ./user-configs.nix {
        inherit template;
      };
  };
in
{
  options.docs = {
    files = lib.mkOption {
      type = with lib.types; lazyAttrsOf docsPageType;
      description = ''
        A set of pages to include in the docs.
      '';
      default = { };
    };
  };

  config.docs = {
    files =
      # TODO: contributing file
      {
        "" = {
          menu.section = "header";
          menu.location = [ "Home" ];
          source = pkgs.callPackage ./readme.nix {
            # TODO: get `availableVersions` and `baseHref` from module options
          };
        };
      }
      // lib.concatMapAttrs (
        name: type:
        let
          title = lib.removeSuffix ".md" name;
          transformer = sourceTransformers.${title} or lib.id;
        in
        lib.optionalAttrs (type == "regular") {
          "user-guide/${title}" = {
            menu.section = "user-guide";
            # TODO: define user-facing titles to show in the menu...
            menu.location = [ title ];
            source = transformer "${user-guide}/${name}";
          };
        }
      ) (builtins.readDir user-guide);

    # Register for inclusion in `all`
    _allInputs = [ "files" ];
  };
}
