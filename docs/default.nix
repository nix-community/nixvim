{
  helpers,
  system,
  nixpkgs,
  nuschtosSearch,
}:
let
  # We overlay a few tweaks into pkgs, for use in the docs
  pkgs = import ./pkgs.nix { inherit system nixpkgs; };
  inherit (pkgs) lib;

  # A stub pkgs instance used while evaluating the nixvim modules for the docs
  # If any non-meta attr is accessed, the eval will throw
  noPkgs =
    let
      # Known suffixes for package sets
      suffixes = [
        "Plugins"
        "Packages"
      ];

      # Predicate for whether an attr name looks like a package set
      # Determines whether stubPackage should recurse
      isPackageSet = name: builtins.any (lib.flip lib.strings.hasSuffix name) suffixes;

      # Need to retain `meta.homepage` if present
      stubPackage =
        prefix: name: package:
        let
          loc = prefix ++ [ name ];
        in
        if isPackageSet name then
          lib.mapAttrs (stubPackage loc) package
        else
          lib.mapAttrs (_: throwAccessError loc) package
          // lib.optionalAttrs (package ? meta) { inherit (package) meta; };

      throwAccessError =
        loc:
        throw "Attempted to access `${
          lib.concatStringsSep "." ([ "pkgs" ] ++ loc)
        }` while rendering the docs.";
    in
    lib.fix (
      self:
      lib.mapAttrs (stubPackage [ ]) pkgs
      // {
        pkgs = self;
        # The following pkgs attrs are required to eval nixvim, even for the docs:
        inherit (pkgs)
          _type
          callPackage
          formats
          runCommand
          runCommandLocal
          stdenv
          stdenvNoCC
          symlinkJoin
          writeShellApplication
          ;
      }
    );

  nixvimPath = toString ./..;

  gitHubDeclaration = user: repo: branch: subpath: {
    url = "https://github.com/${user}/${repo}/blob/${branch}/${subpath}";
    name = "<${repo}/${subpath}>";
  };

  transformOptions =
    opt:
    opt
    // {
      declarations = map (
        decl:
        if lib.hasPrefix nixvimPath (toString decl) then
          gitHubDeclaration "nix-community" "nixvim" "main" (
            lib.removePrefix "/" (lib.removePrefix nixvimPath (toString decl))
          )
        else if decl == "lib/modules.nix" then
          gitHubDeclaration "NixOS" "nixpkgs" "master" decl
        else
          decl
      ) opt.declarations;
    };

  evaledModules = helpers.modules.evalNixvim {
    modules = [
      {
        isDocs = true;
        _module.args.pkgs = lib.mkForce noPkgs;
      }
    ];
  };

  options-json =
    (pkgs.nixosOptionsDoc {
      inherit (evaledModules) options;
      inherit transformOptions;
    }).optionsJSON;

in
lib.fix (
  self:
  {
    inherit options-json;
    inherit (pkgs) nixos-render-docs;

    gfm-alerts-to-admonitions = pkgs.python3.pkgs.callPackage ./gfm-alerts-to-admonitions { };

    man-docs = pkgs.callPackage ./man { inherit options-json; };
  }
  // lib.optionalAttrs (!pkgs.stdenv.isDarwin) {
    # NuschtOS/search does not seem to work on darwin
    search = nuschtosSearch.packages.mkSearch {
      optionsJSON = options-json + "/share/doc/nixos/options.json";
      urlPrefix = "https://github.com/nix-community/nixvim/tree/main";
      title = "Nixvim options search";
      baseHref = "/";
    };

    # Do not check if documentation builds fine on darwin as it fails:
    # > sandbox-exec: pattern serialization length 69298 exceeds maximum (65535)
    docs = pkgs.callPackage ./mdbook {
      inherit evaledModules transformOptions;
      inherit (self) search beta-docs;
    };

    # Beta docs
    beta-docs = evaledModules.config.docs.html.site;
  }
)
