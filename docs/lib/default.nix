{
  lib,
  jq,
  runCommand,
  nixdoc,
  nixvim,
  pageSpecs ? ./pages.nix,
}:

let
  menuConfiguration = lib.evalModules {
    modules = [
      pageSpecs
      ../modules
    ];
  };
  cfg = menuConfiguration.config;
  pages = cfg.functions;

  # Collect all page nodes into a list of page entries
  collectPages =
    pages:
    builtins.concatMap (
      node:
      let
        children = removeAttrs node [ "_page" ];
      in
      lib.optional (node ? _page) node._page ++ lib.optionals (children != { }) (collectPages children)
    ) (builtins.attrValues (removeAttrs pages [ "_category" ]));

  # Normalised page specs
  pageList = collectPages pages;
  pagesToRender = builtins.filter (page: page.target != "") pageList;

  # Function(s) to render page sections
  renderSection = {
    __functor =
      self: section:
      let
        names = builtins.attrNames section;
        tag = builtins.head names;
      in
      assert
        builtins.length names == 1
        || throw "Section type should have 1 attribute, found ${toString (builtins.length names)}.";
      self.${tag} section.${tag};

    # Embed text as-is
    title = title: "printf '# %s\\n' ${lib.escapeShellArg title}";
    file = file: "cat ${file}";
    text = text: "printf '%s\\n' ${lib.escapeShellArg text}";

    # Generates the documentation for library functions using nixdoc.
    # See https://github.com/nix-community/nixdoc
    functions = { file, loc }: ''
      ${lib.getExe nixdoc} \
        --file ${file} \
        --locs function-locations.json \
        --category ${lib.escapeShellArg (lib.showAttrPath loc)} \
        --description "REMOVED BY TAIL" \
        --prefix "lib" \
        --anchor-prefix "" \
      | tail --lines +2
    '';
  };

  result =
    runCommand "nixvim-lib-docs"
      {
        __structuredAttrs = true;
        strictDeps = true;

        nativeBuildInputs = [
          jq
        ];

        functionLocations = import ./function-locations.nix {
          inherit lib;
          rootPath = nixvim;
          functionSet = lib.extend nixvim.lib.overlay;
          pathsToScan = lib.pipe pageList [
            (lib.concatMap (page: page.content))
            (lib.catAttrs "functions")
            (map (x: x.loc))
          ];
          revision = nixvim.rev or "main";
        };

        passthru.config = menuConfiguration;

        passthru.menu = cfg._menu.text;

        passthru.pages = map (page: "${result}/${page.target}") pagesToRender;
      }
      ''
        jq .functionLocations "$NIX_ATTRS_JSON_FILE" > function-locations.json

        mkdir -p "$out"

        ${lib.concatMapStringsSep "\n" (
          {
            title,
            content,
            target,
            ...
          }:
          let
            sections = lib.optional (title != null) { inherit title; } ++ content;
          in
          ''
            ${lib.toShellVars { inherit target; }}
            mkdir -p "$(dirname  "$out/$target")"
            {
            ${lib.pipe sections [
              (map renderSection)
              (lib.intersperse "echo")
              lib.concatLines
            ]}
            } >"$out/$target"
          ''
        ) pagesToRender}
      '';
in
result
