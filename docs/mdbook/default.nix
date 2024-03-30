{
  pkgs,
  lib,
  modules,
  helpers,
  nixosOptionsDoc,
  transformOptions,
  hmOptions,
}:
with lib; let
  options = lib.evalModules {
    inherit modules;
    specialArgs = {inherit pkgs lib helpers;};
  };

  inherit (options.config.meta) nixvimInfo;

  mkMDDoc = options:
    (nixosOptionsDoc {
      inherit options transformOptions;
      warningsAreErrors = false;
    })
    .optionsCommonMark;

  removeUnwanted = attrs:
    builtins.removeAttrs attrs [
      "_module"
      "_freeformOptions"
      "warnings"
      "assertions"
      "content"
    ];

  removeWhitespace = builtins.replaceStrings [" "] [""];

  getSubOptions = opts: path: removeUnwanted (opts.type.getSubOptions path);

  isVisible = opts:
    if isOption opts
    then attrByPath ["visible"] true opts
    else if opts.isOption
    then attrByPath ["index" "options" "visible"] true opts
    else let
      filterFunc =
        filterAttrs
        (
          _: v:
            if isAttrs v
            then isVisible v
            else true
        );

      hasEmptyIndex = (filterFunc opts.index.options) == {};
      hasEmptyComponents = (filterFunc opts.components) == {};
    in
      !hasEmptyIndex || !hasEmptyComponents;

  wrapModule = path: opts: isOpt: rec {
    index = {
      options =
        if isOpt
        then opts
        else filterAttrs (_: component: component.isOption && (isVisible component)) opts;
      path = removeWhitespace (concatStringsSep "/" path);
      moduleDoc =
        if builtins.length path >= 2 && lib.hasAttrByPath path nixvimInfo
        then let
          info = lib.getAttrFromPath path nixvimInfo;
          maintainers = lib.unique (options.config.meta.maintainers.${info.file} or []);
          maintainersNames = builtins.map (m: m.name) maintainers;
        in
          "# ${lib.last path}\n\n"
          + (lib.optionalString (info.description != null) "${info.description}\n\n")
          + (lib.optionalString (info.url != null) "**Url:** [${info.url}](${info.url})\n\n")
          + (lib.optionalString (builtins.length maintainers > 0)
            "**Maintainers:** ${lib.concatStringsSep ", " maintainersNames}\n\n")
        else null;
    };

    components =
      if isOpt
      then {}
      else filterAttrs (_: component: !component.isOption && (isVisible component)) opts;

    hasComponents = components != {};

    isOption = isOpt;
  };

  processModulesRec = modules: let
    recurse = path: mods: let
      g = name: opts:
        if !isOption opts
        then wrapModule (path ++ [name]) (recurse (path ++ [name]) opts) false
        else let
          subOpts = getSubOptions opts (path ++ [name]);
        in
          if subOpts != {}
          then
            wrapModule
            (path ++ [name])
            (
              (recurse (path ++ [name]) subOpts)
              // {
                # This is necessary to include the submodule option's definition in the docs (description, type, etc.)
                # For instance, this helps submodules like "autoCmd" to include their base definitions and examples in the docs
                # Though there might be a better, less "hacky" solution than this.
                ${name} = recursiveUpdate opts {
                  isOption = true;
                  type.getSubOptions = _: _: {}; # Used to exclude suboptions from the submodule definition itself
                };
              }
            )
            false
          else wrapModule (path ++ [name]) opts true;
    in
      mapAttrs g mods;
  in
    foldlAttrs
    (
      acc: name: opts: let
        group =
          if !opts.hasComponents
          then "Neovim Options"
          else "none";

        last =
          acc.${group}
          or {
            index = {
              options = {};
              path = removeWhitespace "${group}";
              moduleDoc = null;
            };
            components = {};
            isGroup = true;
            hasComponents = false;
          };

        isOpt = !opts.hasComponents && (isOption opts.index.options);
      in
        acc
        // {
          ${group} = recursiveUpdate last {
            index.options = optionalAttrs isOpt {
              ${name} = opts.index.options;
            };

            components = optionalAttrs (!isOpt) {
              ${name} = recursiveUpdate opts {
                index.path =
                  removeWhitespace
                  (
                    concatStringsSep "/"
                    (
                      (optional (group != "none") group) ++ [opts.index.path]
                    )
                  );
                hasComponents = true;
              };
            };

            hasComponents = last.components != {};
          };
        }
    )
    {}
    (recurse [] modules);

  mapModulesToString = f: modules: let
    recurse = mods: let
      g = name: opts:
        if (opts ? "isGroup")
        then
          if name != "none"
          then (f name opts) + ("\n" + recurse opts.components)
          else recurse opts.components
        else if opts.hasComponents
        then (f name opts) + ("\n" + recurse opts.components)
        else f name opts;
    in
      concatStringsSep "\n" (mapAttrsToList g mods);
  in
    recurse modules;

  docs = rec {
    modules = processModulesRec (removeUnwanted options.options);
    commands =
      mapModulesToString
      (
        name: opts: let
          isBranch =
            if (hasSuffix "index" opts.index.path)
            then true
            else opts.hasComponents;
          path =
            if isBranch
            then "${opts.index.path}/index.md"
            else "${opts.index.path}.md";
        in
          (optionalString isBranch
            "mkdir -p ${opts.index.path}\n")
          + (
            if opts.index.moduleDoc == null
            then "cp ${mkMDDoc opts.index.options} ${path}"
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
      )
      modules;
  };

  mdbook = {
    nixvimOptions =
      mapModulesToString
      (
        name: opts: let
          isBranch =
            if name == "index"
            then true
            else opts.hasComponents && opts.index.options != {};

          path =
            if isBranch
            then "${opts.index.path}/index.md"
            else if !opts.hasComponents
            then "${opts.index.path}.md"
            else "";

          indentLevel = with builtins; length (filter isString (split "/" opts.index.path)) - 1;

          padding = concatStrings (builtins.genList (_: "\t") indentLevel);
        in "${padding}- [${name}](${path})"
      )
      docs.modules;
  };

  prepareMD = ''
    # Copy inputs into the build directory
    cp -r --no-preserve=all $inputs/* ./
    cp ${../../CONTRIBUTING.md} ./CONTRIBUTING.md
    cp -r ${../user-guide} ./user-guide
    cp -r ${../modules} ./modules

    # Copy the generated MD docs into the build directory
    # Using pkgs.writeShellScript helps to avoid the "bash: argument list too long" error
    bash -e ${pkgs.writeShellScript "copy_docs" docs.commands}

    # Prepare SUMMARY.md for mdBook
    # Using pkgs.writeText helps to avoid the same error as above
    substituteInPlace ./SUMMARY.md \
      --replace-fail "@NIXVIM_OPTIONS@" "$(cat ${pkgs.writeText "nixvim-options-summary.md" mdbook.nixvimOptions})"

    substituteInPlace ./modules/hm.md \
      --replace-fail "@HM_OPTIONS@" "$(cat ${mkMDDoc hmOptions})"
  '';
in
  pkgs.stdenv.mkDerivation {
    name = "nixvim-docs";

    phases = ["buildPhase"];

    buildInputs = [pkgs.mdbook];
    inputs = sourceFilesBySuffices ./. [".md" ".toml" ".js"];

    buildPhase = ''
      dest=$out/share/doc
      mkdir -p $dest
      ${prepareMD}
      mdbook build
      cp -r ./book/* $dest
    '';
  }
