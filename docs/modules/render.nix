{
  lib,
  path,
  runCommand,
  nixdoc,
  multipage-render-docs,
  python3,
  transformOptions,
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

  # Convert the doc-options list into the structure required for options.json
  # See https://github.com/NixOS/nixpkgs/blob/e2078ef3/nixos/lib/make-options-doc/default.nix#L167-L176
  processOptions = lib.flip lib.pipe [
    (lib.filter (opt: opt.visible && !opt.internal))
    (map transformOptions)
    (map (opt: {
      inherit (opt) name;
      value = removeAttrs opt [
        "name"
        "visible"
        "internal"
      ];
    }))
    builtins.listToAttrs
  ];

  # For performance reasons, all options are rendered in a single pass,
  # we use multipage-render-docs instead of nixos-render-docs to keep
  # options grouped by section ID.
  optionSections =
    runCommand "${name}-option-doc-sections"
      {
        __structuredAttrs = true;
        strictDeps = true;

        nativeBuildInputs = [
          multipage-render-docs
        ];

        options = lib.pipe pagesToRender [
          (lib.concatMap (page: page.content))
          (lib.filter (section: section ? options))
          (map ({ id, options }: lib.nameValuePair id (processOptions options)))
          lib.listToAttrs
        ];

        env = {
          # TODO: specify our Nixpkgs revision
          # See https://github.com/NixOS/nixpkgs/blob/3e41b24a/pkgs/by-name/ni/nixos-render-docs/src/nixos_render_docs/options.py#L55-L64
          NIXPKGS_REVISION = nixvim.inputs.nixpkgs.rev or "master";

          # https://github.com/NixOS/nixpkgs/blob/3e41b24a/doc/manpage-urls.json
          MANPAGE_URLS = "${path}/doc/manpage-urls.json";
        };
      }
      ''
        multipage-render-docs > "$out"
      '';

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

        # TODO: optimize build closure by omitting when there are no options sections
        inherit optionSections;

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
