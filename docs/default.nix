{
  pkgs,
  lib,
  modules,
  ...
}:
with lib; let
  options = lib.evalModules {
    inherit modules;
    specialArgs = {inherit pkgs lib;};
  };

  mkMDDoc = options:
    (pkgs.nixosOptionsDoc {
      options = filterAttrs (k: _: k != "_module") options;
      warningsAreErrors = false;
      transformOptions = opts:
        opts
        // {
          declarations = with builtins;
            map
            (
              decl:
                if hasPrefix "/nix/store/" decl
                then let
                  filepath = toString (match "^/nix/store/[^/]*/(.*)" decl);
                in {
                  url = "https://github.com/nix-community/nixvim/blob/main/${filepath}";
                  name = filepath;
                }
                else decl
            )
            opts.declarations;
        };
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

  wrapModule = path: opts: isOpt: rec {
    index = {
      options =
        if isOpt
        then opts
        else filterAttrs (_: component: component.isOption) opts;
      path = concatStringsSep "/" path;
    };

    components =
      if isOpt
      then {}
      else filterAttrs (_: component: !component.isOption) opts;

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
                index.path = removeWhitespace (concatStringsSep "/" ((optional (group != "none") group) ++ [opts.index.path]));
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
          + "cp ${mkMDDoc opts.index.options} ${path}"
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
    cp ${../CONTRIBUTING.md} ./CONTRIBUTING.md

    # Copy the generated MD docs into the build directory
    # Using pkgs.writeShellScript helps to avoid the "bash: argument list too long" error
    ${pkgs.writeShellScript "copy_docs" docs.commands}

    # Prepare SUMMARY.md for mdBook
    # Using pkgs.writeText helps to avoid the same error as above
    substituteInPlace ./SUMMARY.md \
      --replace "@NIXVIM_OPTIONS@" "$(cat ${pkgs.writeText "nixvim-options-summary.md" mdbook.nixvimOptions})"
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
