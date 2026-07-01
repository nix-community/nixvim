{
  lib,
  runCommand,
  nixdoc,
  python3,
  nixvim,
}:

name: modules:
let
  menuConfiguration = lib.evalModules {
    modules = [ ../modules ] ++ lib.toList modules;
  };
  cfg = menuConfiguration.config;

  # Page specs
  inherit (cfg._menu) pages;
  pagesToRender = builtins.filter (page: page.target != "") pages;

  pageModel = lib.listToAttrs (
    map (
      {
        loc,
        title,
        target,
        content,
        ...
      }:
      lib.nameValuePair (lib.showAttrPath loc) {
        inherit target;

        sections =
          lib.optional (title != null) {
            id = "title";
            type = "text";
            value = "# ${title}\n";
          }
          ++ map (
            section:
            let
              names = lib.remove "id" (builtins.attrNames section);
              type = builtins.head names;
              skipValue = lib.elem type [
                # Options are rendered in the optionSections derivation for efficiency.
                # Here, we only need the section id.
                "options"
              ];
            in
            assert
              builtins.length names == 1
              || throw "Section type should have `id` and 1 other attribute, found ${toString (builtins.length names)}.";
            {
              inherit type;
              inherit (section) id;
              ${if skipValue then null else "value"} = section.${type};
            }
          ) content;
      }
    ) pagesToRender
  );

  result =
    runCommand name
      {
        __structuredAttrs = true;
        strictDeps = true;

        nativeBuildInputs = [
          nixdoc
        ];

        # TODO: optimize build closure by omitting when there are no functions sections
        functionLocations = import ./function-locations.nix {
          inherit lib;
          rootPath = nixvim;
          functionSet = lib.extend nixvim.lib.overlay;
          pathsToScan = lib.pipe pages [
            (lib.concatMap (page: page.content))
            (lib.catAttrs "functions")
            (map (x: x.loc))
          ];
          revision = nixvim.rev or "main";
        };

        inherit pageModel;

        passthru.config = menuConfiguration;

        passthru.menu = cfg._menu.text;

        passthru.pages = map (page: "${result}/${page.target}") pagesToRender;
      }
      ''
        ${python3.interpreter} ${./render.py}
      '';
in
result
