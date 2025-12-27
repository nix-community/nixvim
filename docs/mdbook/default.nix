{
  pkgs,
  callPackage,
  runCommand,
  lib,
  configuration,
  nixosOptionsDoc,
  transformOptions,
  search,
  lib-docs,
  # The root directory of the site
  baseHref ? "/",
  # A list of all available docs that should be linked to
  # Each element should contain { branch; nixpkgsBranch; baseHref; status; }
  availableVersions ? [ ],
}:
let
  inherit (configuration.config.meta) nixvimInfo;

  mkOptionsDocMD =
    options:
    (nixosOptionsDoc {
      inherit options transformOptions;
    }).optionsCommonMark;

  removeUnwanted =
    attrs:
    # FIXME: We incorrectly remove _freeformOptions here.
    #
    # However we can't fix the bug because we derive page names from attrnames;
    # the correct behaviour would be to ignore attrnames and use option locs.
    #
    # As a workaround, merge the freeform options at the top of these attrs,
    # however this can run into name conflicts 😢
    #
    # We should move this workaround to where we decide the page name and
    # whether to nest into a sub-page, so that we can keep the original
    # _freeformOptions attr as intended.
    attrs._freeformOptions or { }
    // removeAttrs attrs [
      "_module"
      "_freeformOptions"
      "warnings"
      "assertions"
      "content"
    ];

  removeWhitespace = builtins.replaceStrings [ " " ] [ "" ];

  getSubOptions =
    opt:
    let
      visible = opt.visible or true;
      visible' = if lib.isBool visible then visible else visible != "shallow";
      subOpts = opt.type.getSubOptions opt.loc;
    in
    lib.optionalAttrs visible' (removeUnwanted subOpts);

  isVisible =
    let
      test =
        opt:
        let
          internal = opt.internal or false;
          visible = opt.visible or true;
          visible' = if lib.isBool visible then visible else visible != "transparent";
        in
        visible' && !internal;

      # FIXME: isVisible is not a perfect check;
      # it will false-positive on `visible = "transparent"`
      hasVisible = opts: lib.any (v: lib.isAttrs v -> isVisible v) (lib.attrValues opts);
    in
    opts:
    if lib.isOption opts then
      test opts
    else if opts.isOption then
      test opts.index.options
    else
      lib.any hasVisible [
        opts.index.options
        opts.components
      ];

  wrapOptionDocPage = path: opts: isOpt: rec {
    index = {
      # We split pages into "options" and "components".
      # Options are shown on this page, while components create their own sub-pages.
      options =
        if isOpt then
          opts
        else
          lib.filterAttrs (_: component: component.isOption && isVisible component) opts;
      path = removeWhitespace (lib.concatStringsSep "/" path);
      docSummaryMD =
        let
          info = lib.attrByPath path { } nixvimInfo;
          maintainers = lib.unique (configuration.config.meta.maintainers.${info.file} or [ ]);
          maintainersNames = map maintToMD maintainers;
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
        lib.filterAttrs (_: component: !component.isOption && isVisible component) opts;

    hasComponents = components != { };

    isOption = isOpt;
  };

  processOptionsRec =
    options:
    let
      go =
        path:
        lib.mapAttrs (
          name: opts:
          # This node is not an option, keep recursing
          if !lib.isOption opts then
            wrapOptionDocPage (path ++ [ name ]) (go (path ++ [ name ]) opts) false
          else
            let
              subOpts = getSubOptions opts;
            in
            # If this node is an option with sub-options...
            # Pass wrapOptionDocPage a set containing it and its sub-options.
            # In practice, this creates a dedicated page for the option and its sub-options.
            if subOpts != { } then
              wrapOptionDocPage (path ++ [ name ]) (
                (go (path ++ [ name ]) subOpts)
                // lib.optionalAttrs (isVisible opts) {
                  # This is necessary to include the option itself in the docs.
                  # For instance, this helps submodules like "autoCmd" to include their base declaration in the docs.
                  # Though there must be a better, less "hacky" solution than this.
                  ${name} = lib.recursiveUpdate opts {
                    # FIXME: why do we need this?????
                    isOption = true;
                    # Exclude suboptions from the submodule definition itself,
                    # as they are already part of this set.
                    type.getSubOptions = _: _: { };
                  };
                }
              ) false
            # This node is an option without sub-options
            else
              wrapOptionDocPage (path ++ [ name ]) opts true
        );
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
              docSummaryMD = null;
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
    ) { } (go [ ] options);

  mapOptionsToStringRecursive =
    set: f:
    let
      go =
        mods:
        lib.concatMapAttrsStringSep "\n" (
          name: opts:
          if (opts ? "isGroup") then
            if name != "none" then (f name opts) + ("\n" + go opts.components) else go opts.components
          else if opts.hasComponents then
            (f name opts) + ("\n" + go opts.components)
          else
            f name opts
        ) mods;
    in
    go set;

  docs = rec {
    optionSet = processOptionsRec (removeUnwanted configuration.options);
    commands = mapOptionsToStringRecursive optionSet (
      name: opts:
      let
        isBranch = if (lib.hasSuffix "index" opts.index.path) then true else opts.hasComponents;
        # Ensure `path` is escaped because we use it in a shell script
        path = lib.strings.escapeShellArg (
          if isBranch then "${opts.index.path}/index.md" else "${opts.index.path}.md"
        );
      in
      (lib.optionalString isBranch "mkdir -p ${opts.index.path}\n")
      + (
        if opts.index.docSummaryMD == null then
          "cp ${mkOptionsDocMD opts.index.options} ${path}"
        else
          # Including docSummaryMD's text directly will result in bash interpreting special chars,
          # write it to the nix store and `cat` the file instead.
          # FIXME: avoid an extra derivation using something like `escapeShellArg`?
          ''
            {
            cat ${pkgs.writeText "doc-summary-${name}" opts.index.docSummaryMD}
            cat ${mkOptionsDocMD opts.index.options}
            } > ${path}
          ''
      )
    );
  };

  mdbook = {
    nixvimOptionsSummary = mapOptionsToStringRecursive docs.optionSet (
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
    );

    # A list of platform-specific docs
    # [ { name, file, path, configuration } ]
    platformOptions =
      lib.forEach
        [
          "nixos"
          "hm"
          "darwin"
        ]
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
          file = mkOptionsDocMD (removeUnwanted configuration.options);
          path = "./platforms/${filename}.md";
        });

    # Markdown summary for the table of contents
    platformOptionsSummary = lib.foldl (
      text: { name, path, ... }: text + "\n\t- [${name}](${path})"
    ) "" mdbook.platformOptions;

    # Attrset of { filePath = renderedDocs; }
    platformOptionsFiles = lib.listToAttrs (
      map (
        { path, file, ... }:
        {
          name = path;
          value = file;
        }
      ) mdbook.platformOptions
    );
  };

  # Zip the list of attrs into an attr of lists, for use as bash arrays
  zippedVersions =
    assert lib.assertMsg
      (lib.all (o: o ? branch && o ? nixpkgsBranch && o ? baseHref && o ? status) availableVersions)
      ''
        Expected all "availableVersions" docs entries to contain { branch, nixpkgsBranch, baseHref, status } attrs!
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
      (lib.fileset.fileFilter (
        { type, hasExt, ... }:
        type == "regular"
        && lib.any hasExt [
          "css"
          "js"
          "md"
          "toml"
        ]
      ) ./.)
    ];
  };

  contributing = finalAttrs.passthru.fix-links ../../CONTRIBUTING.md;
  maintaining = finalAttrs.passthru.fix-links ../../MAINTAINING.md;

  buildPhase = ''
    mkdir -p $out

    # Copy (and flatten) src into the build directory
    cp -r --no-preserve=all $src/* ./
    mv ./docs/* ./ && rmdir ./docs
    mv ./mdbook/* ./ && rmdir ./mdbook

    # Copy the contributing and maintaining files
    cp $contributing ./CONTRIBUTING.md
    substitute $maintaining ./MAINTAINING.md \
      --replace-fail 'This file' 'This page'

    # Symlink the function docs
    for path in ${lib-docs}/*
    do
      echo "symlinking \"$path\" to \"$(basename "$path")\""
      ln -s "$path" $(basename "$path")
    done

    # Copy the generated MD docs into the build directory
    bash -e ${finalAttrs.passthru.copy-docs}

    # Copy the generated MD docs for the wrapper options
    for path in "''${!platformOptionsFiles[@]}"
    do
      file="''${platformOptionsFiles[$path]}"
      cp "$file" "$path"
    done

    # Patch book.toml
    substituteInPlace ./book.toml \
      --replace-fail "@SITE_URL@" "$baseHref"

    # Patch SUMMARY.md - which defiens mdBook's table of contents
    substituteInPlace ./SUMMARY.md \
      --replace-fail "@FUNCTIONS_MENU@" "$functionsSummary" \
      --replace-fail "@PLATFORM_OPTIONS@" "$platformOptionsSummary" \
      --replace-fail "@NIXVIM_OPTIONS@" "$nixvimOptionsSummary"

    # Patch index.md
    substituteInPlace ./index.md \
      --replace-fail "@README@" "$(cat ${finalAttrs.passthru.readme})" \
      --replace-fail "@DOCS_VERSIONS@" "$(cat ${finalAttrs.passthru.docs-versions})"

    # Patch user-configs
    substituteInPlace ./user-guide/config-examples.md \
      --replace-fail "@USER_CONFIGS@" "$(cat ${finalAttrs.passthru.user-configs})"

    mdbook build
    cp -r ./book/* $out
    mkdir -p $out/search
    cp -r ${finalAttrs.passthru.search}/* $out/search
  '';

  inherit baseHref;

  inherit (mdbook)
    nixvimOptionsSummary
    platformOptionsSummary
    platformOptionsFiles
    ;

  functionsSummary = lib-docs.menu;

  passthru = {
    fix-links = callPackage ../fix-links {
      # FIXME: determine values from availableVersions & baseHref
      docsUrl = "https://nix-community.github.io/nixvim/";
      githubUrl = "https://github.com/nix-community/nixvim/blob/main/";
    };
    copy-docs = pkgs.writeShellScript "copy-docs" docs.commands;
    readme =
      runCommand "readme"
        {
          start = "<!-- START DOCS -->";
          end = "<!-- STOP DOCS -->";
          src = finalAttrs.passthru.fix-links ../../README.md;
        }
        ''
          # extract relevant section of the README
          sed -n "/$start/,/$end/p" $src > $out
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
          statuses = zippedVersions.status or [ ];
          current = baseHref;
        }
        ''
          touch "$out"
          for i in ''${!branches[@]}; do
            branch="''${branches[i]}"
            nixpkgs="''${nixpkgsBranches[i]}"
            baseHref="''${baseHrefs[i]}"
            linkText="\`$branch\` branch"
            status="''${statuses[i]}"

            link=
            suffix=
            if [ "$baseHref" = "$current" ]; then
              # Don't bother linking to ourselves
              link="$linkText"
              suffix=" _(this page)_"
            else
              link="[$linkText]($baseHref)"
            fi

            statusClass=
            statusText=
            if [ "$status" = "beta" ]; then
              statusClass="label label-info"
              statusText=Beta
            elif [ "$status" = "deprecated" ]; then
              statusClass="label label-warning"
              statusText=Deprecated
            fi

            {
              echo -n '- '
              if [ -n "$statusClass" ] && [ -n "$statusText" ]; then
                echo -n '<span class="'"$statusClass"'">'"$statusText"'</span> '
              fi
              echo -n "The $link"
              echo -n ", for use with nixpkgs \`$nixpkgs\`"
              echo "$suffix"
            } >> "$out"
          done
        '';
    user-configs = callPackage ../user-configs { };
  };
})
