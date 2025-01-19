{
  pkgs,
  callPackage,
  runCommand,
  lib,
  evaledModules,
  nixosOptionsDoc,
  transformOptions,
  search,
  # The root directory of the site
  baseHref ? "/",
  # A list of all available docs that should be linked to
  # Each element should contain { branch; nixpkgsBranch; baseHref; }
  availableVersions ? [ ],
}:
let
  inherit (evaledModules.config.meta) nixvimInfo;

  mkMDDoc =
    options:
    (nixosOptionsDoc {
      inherit options transformOptions;
    }).optionsCommonMark;

  removeUnwanted =
    attrs:
    builtins.removeAttrs attrs [
      "_module"
      "_freeformOptions"
      "warnings"
      "assertions"
      "content"
    ];

  removeWhitespace = builtins.replaceStrings [ " " ] [ "" ];

  getSubOptions =
    opts: path: lib.optionalAttrs (isVisible opts) (removeUnwanted (opts.type.getSubOptions path));

  isVisible =
    opts:
    if lib.isOption opts then
      opts.visible or true && !(opts.internal or false)
    else if opts.isOption then
      opts.index.options.visible or true && !(opts.index.options.internal or false)
    else
      let
        filterFunc = lib.filterAttrs (_: v: if lib.isAttrs v then isVisible v else true);

        hasEmptyIndex = (filterFunc opts.index.options) == { };
        hasEmptyComponents = (filterFunc opts.components) == { };
      in
      !hasEmptyIndex || !hasEmptyComponents;

  wrapModule = path: opts: isOpt: rec {
    index = {
      options =
        if isOpt then
          opts
        else
          lib.filterAttrs (_: component: component.isOption && (isVisible component)) opts;
      path = removeWhitespace (lib.concatStringsSep "/" path);
      moduleDoc =
        let
          info = lib.attrByPath path { } nixvimInfo;
          maintainers = lib.unique (evaledModules.config.meta.maintainers.${info.file} or [ ]);
          maintainersNames = builtins.map maintToMD maintainers;
          maintToMD = m: if m ? github then "[${m.name}](https://github.com/${m.github})" else m.name;
        in
        # Make sure this path has a valid info attrset
        if info ? file && info ? description && info ? url then
          "# ${lib.last path}\n\n"
          + (lib.optionalString (info.url != null) "**URL:** [${info.url}](${info.url})\n\n")
          + (lib.optionalString (
            maintainers != [ ]
          ) "**Maintainers:** ${lib.concatStringsSep ", " maintainersNames}\n\n")
          + lib.optionalString (info.description != null) ''

            ---

            ${info.description}

          ''
        else
          null;
    };

    components =
      if isOpt then
        { }
      else
        lib.filterAttrs (_: component: !component.isOption && (isVisible component)) opts;

    hasComponents = components != { };

    isOption = isOpt;
  };

  processModulesRec =
    modules:
    let
      recurse =
        path: mods:
        let
          g =
            name: opts:
            if !lib.isOption opts then
              wrapModule (path ++ [ name ]) (recurse (path ++ [ name ]) opts) false
            else
              let
                subOpts = getSubOptions opts (path ++ [ name ]);
              in
              if subOpts != { } then
                wrapModule (path ++ [ name ]) (
                  (recurse (path ++ [ name ]) subOpts)
                  // {
                    # This is necessary to include the submodule option's definition in the docs (description, type, etc.)
                    # For instance, this helps submodules like "autoCmd" to include their base definitions and examples in the docs
                    # Though there might be a better, less "hacky" solution than this.
                    ${name} = lib.recursiveUpdate opts {
                      isOption = true;
                      type.getSubOptions = _: _: { }; # Used to exclude suboptions from the submodule definition itself
                    };
                  }
                ) false
              else
                wrapModule (path ++ [ name ]) opts true;
        in
        lib.mapAttrs g mods;
    in
    lib.foldlAttrs (
      acc: name: opts:
      let
        group = if !opts.hasComponents then "Neovim Options" else "none";

        last =
          acc.${group} or {
            index = {
              options = { };
              path = removeWhitespace "${group}";
              moduleDoc = null;
            };
            components = { };
            isGroup = true;
            hasComponents = false;
          };

        isOpt = !opts.hasComponents && (lib.isOption opts.index.options);
      in
      acc
      // {
        ${group} = lib.recursiveUpdate last {
          index.options = lib.optionalAttrs isOpt { ${name} = opts.index.options; };

          components = lib.optionalAttrs (!isOpt) {
            ${name} = lib.recursiveUpdate opts {
              index.path = removeWhitespace (
                lib.concatStringsSep "/" ((lib.optional (group != "none") group) ++ [ opts.index.path ])
              );
              hasComponents = true;
            };
          };

          hasComponents = last.components != { };
        };
      }
    ) { } (recurse [ ] modules);

  mapModulesToString =
    f: modules:
    let
      recurse =
        mods:
        let
          g =
            name: opts:
            if (opts ? "isGroup") then
              if name != "none" then (f name opts) + ("\n" + recurse opts.components) else recurse opts.components
            else if opts.hasComponents then
              (f name opts) + ("\n" + recurse opts.components)
            else
              f name opts;
        in
        lib.concatStringsSep "\n" (lib.mapAttrsToList g mods);
    in
    recurse modules;

  docs = rec {
    modules = processModulesRec (removeUnwanted evaledModules.options);
    commands = mapModulesToString (
      name: opts:
      let
        isBranch = if (lib.hasSuffix "index" opts.index.path) then true else opts.hasComponents;
        path = if isBranch then "${opts.index.path}/index.md" else "${opts.index.path}.md";
      in
      (lib.optionalString isBranch "mkdir -p ${opts.index.path}\n")
      + (
        if opts.index.moduleDoc == null then
          "cp ${mkMDDoc opts.index.options} ${path}"
        else
          # Including moduleDoc's text directly will result in bash interpreting special chars,
          # write it to the nix store and `cat` the file instead.
          ''
            {
            cat ${pkgs.writeText "module-doc" opts.index.moduleDoc}
            cat ${mkMDDoc opts.index.options}
            } > ${path}
          ''
      )
    ) modules;
  };

  mdbook = {
    nixvimOptionsSummary = mapModulesToString (
      name: opts:
      let
        isBranch = name == "index" || (opts.hasComponents && opts.index.options != { });

        path =
          if isBranch then
            "${opts.index.path}/index.md"
          else if !opts.hasComponents then
            "${opts.index.path}.md"
          else
            "";

        indentLevel = lib.count (c: c == "/") (lib.stringToCharacters opts.index.path);

        padding = lib.strings.replicate indentLevel "\t";
      in
      "${padding}- [${name}](${path})"
    ) docs.modules;

    # A list of platform-specific docs
    # [ { name, file, path, configuration } ]
    wrapperOptions =
      builtins.map
        (filename: rec {
          # Eval a configuration for the platform's module
          configuration = lib.evalModules {
            modules = [
              ../../wrappers/modules/${filename}.nix
              {
                # Ignore definitions for missing options
                _module.check = false;
              }
            ];
          };
          # Also include display name, filepath, and rendered docs
          inherit (configuration.config.meta.wrapper) name;
          file = mkMDDoc (removeUnwanted configuration.options);
          path = "./platforms/${filename}.md";
        })
        [
          "nixos"
          "hm"
          "darwin"
        ];

    # Markdown summary for the table of contents
    wrapperOptionsSummary = lib.foldl (
      text: { name, path, ... }: text + "\n\t- [${name}](${path})"
    ) "" mdbook.wrapperOptions;

    # Attrset of { filePath = renderedDocs; }
    wrapperOptionsFiles = lib.listToAttrs (
      builtins.map (
        { path, file, ... }:
        {
          name = path;
          value = file;
        }
      ) mdbook.wrapperOptions
    );
  };

  # Zip the list of attrs into an attr of lists, for use as bash arrays
  zippedVersions =
    assert lib.assertMsg
      (lib.all (o: o ? branch && o ? nixpkgsBranch && o ? baseHref) availableVersions)
      ''
        Expected all "availableVersions" docs entries to contain { branch, nixpkgsBranch, baseHref } attrs!
      '';
    lib.zipAttrs availableVersions;
in

pkgs.stdenv.mkDerivation (finalAttrs: {
  name = "nixvim-docs";

  # Use structured attrs to avoid "bash: argument list too long" errors
  __structuredAttrs = true;

  phases = [ "buildPhase" ];

  buildInputs = [
    pkgs.mdbook
    pkgs.mdbook-alerts
  ];

  # Build a source from the fileset containing the following paths,
  # as well as all .md, .toml, & .js files in this directory
  src = lib.fileset.toSource {
    root = ../../.;
    fileset = lib.fileset.unions [
      ../user-guide
      ../platforms
      ../../CONTRIBUTING.md
      (lib.fileset.fileFilter (
        { type, hasExt, ... }:
        type == "regular"
        && lib.any hasExt [
          "md"
          "toml"
          "js"
        ]
      ) ./.)
    ];
  };

  buildPhase = ''
    dest=$out/share/doc
    mkdir -p $dest

    # Copy (and flatten) src into the build directory
    cp -r --no-preserve=all $src/* ./
    mv ./docs/* ./ && rmdir ./docs
    mv ./mdbook/* ./ && rmdir ./mdbook

    # Copy the generated MD docs into the build directory
    bash -e ${finalAttrs.passthru.copy-docs}

    # Copy the generated MD docs for the wrapper options
    for path in "''${!wrapperOptionsFiles[@]}"
    do
      file="''${wrapperOptionsFiles[$path]}"
      cp "$file" "$path"
    done

    # Patch book.toml
    substituteInPlace ./book.toml \
      --replace-fail "@SITE_URL@" "$baseHref"

    # Patch SUMMARY.md - which defiens mdBook's table of contents
    substituteInPlace ./SUMMARY.md \
      --replace-fail "@PLATFORM_OPTIONS@" "$wrapperOptionsSummary" \
      --replace-fail "@NIXVIM_OPTIONS@" "$nixvimOptionsSummary"

    # Patch index.md
    substituteInPlace ./index.md \
      --replace-fail "@README@" "$(cat ${finalAttrs.passthru.readme})" \
      --replace-fail "@DOCS_VERSIONS@" "$(cat ${finalAttrs.passthru.docs-versions})"

    # Patch user-configs
    substituteInPlace ./user-guide/config-examples.md \
      --replace-fail "@USER_CONFIGS@" "$(cat ${finalAttrs.passthru.user-configs})"

    mdbook build
    cp -r ./book/* $dest
    mkdir -p $dest/search
    cp -r ${finalAttrs.passthru.search}/* $dest/search
  '';

  inherit baseHref;

  inherit (mdbook)
    nixvimOptionsSummary
    wrapperOptionsSummary
    wrapperOptionsFiles
    ;

  passthru = {
    copy-docs = pkgs.writeShellScript "copy-docs" docs.commands;
    readme =
      runCommand "readme"
        {
          start = "<!-- START DOCS -->";
          end = "<!-- STOP DOCS -->";
          baseurl = "https://nix-community.github.io/nixvim/";
          src = ../../README.md;
        }
        ''
          # extract relevant section of the README
          sed -n "/$start/,/$end/p" $src > $out
          # replace absolute links
          substituteInPlace $out --replace-quiet "$baseurl" "./"
          # TODO: replace .html with .md
        '';
    search = search.override {
      baseHref = finalAttrs.baseHref + "search/";
    };
    docs-versions =
      runCommand "docs-versions"
        {
          __structuredAttrs = true;
          branches = zippedVersions.branch or [ ];
          nixpkgsBranches = zippedVersions.nixpkgsBranch or [ ];
          baseHrefs = zippedVersions.baseHref or [ ];
          current = baseHref;
        }
        ''
          touch "$out"
          for i in ''${!branches[@]}; do
            branch="''${branches[i]}"
            nixpkgs="''${nixpkgsBranches[i]}"
            baseHref="''${baseHrefs[i]}"
            linkText="\`$branch\` branch"

            link=
            suffix=
            if [ "$baseHref" = "$current" ]; then
              # Don't bother linking to ourselves
              link="$linkText"
              suffix=" _(this page)_"
            else
              link="[$linkText]($baseHref)"
            fi

            echo "- The $link, for use with nixpkgs \`$nixpkgs\`$suffix" >> "$out"
          done
        '';
    user-configs = callPackage ../user-configs { };
  };
})
