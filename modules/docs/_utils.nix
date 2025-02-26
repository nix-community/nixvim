{ lib, ... }:
let
  transformOption =
    let
      root = builtins.toString ../../.;
      mkGitHubDeclaration = user: repo: branch: subpath: {
        url = "https://github.com/${user}/${repo}/blob/${branch}/${subpath}";
        name = "<${repo}/${subpath}>";
      };
      transformDeclaration =
        decl:
        if lib.hasPrefix root (builtins.toString decl) then
          mkGitHubDeclaration "nix-community" "nixvim" "main" (
            lib.removePrefix "/" (lib.strings.removePrefix root (builtins.toString decl))
          )
        else if decl == "lib/modules.nix" then
          mkGitHubDeclaration "NixOS" "nixpkgs" "master" decl
        else
          decl;
    in
    opt: opt // { declarations = builtins.map transformDeclaration opt.declarations; };
in
{
  options.docs._utils = lib.mkOption {
    type = with lib.types; lazyAttrsOf raw;
    description = "internal utils, modules, functions, etc";
    default = { };
    internal = true;
    visible = false;
  };

  config.docs._utils = {
    /**
      Uses `lib.optionAttrSetToDocList` to produce a list of docs-options.

      A doc-option has the following attrs, as expected by `nixos-render-docs`:

      ```
      {
        loc,
        name, # rendered with `showOption loc`
        description,
        declarations,
        internal,
        visible, # normalised to a boolean
        readOnly,
        type, # normalised to `type.description`
        default,? # rendered with `lib.options.renderOptionValue`
        example,? # rendered with `lib.options.renderOptionValue`
        relatedPackages,?
      }
      ```

      Additionally, sub-options are recursively flattened into the list,
      unless `visible == "shallow"` or `visible == false`.

      This function extends `lib.optionAttrSetToDocList` by also filtering out
      invisible and internal options, and by applying Nixvim's `transformOption`
      function.

      The implementation is based on `pkgs.nixosOptionsDoc`:
      https://github.com/NixOS/nixpkgs/blob/e2078ef3/nixos/lib/make-options-doc/default.nix#L117-L126
    */
    mkOptionList = lib.flip lib.pipe [
      (lib.flip builtins.removeAttrs [ "_module" ])
      lib.optionAttrSetToDocList
      (builtins.map transformOption)
      (builtins.filter (opt: opt.visible && !opt.internal))
      # TODO: consider supporting `relatedPackages`
      # See https://github.com/NixOS/nixpkgs/blob/61235d44/lib/options.nix#L103-L104
      # and https://github.com/NixOS/nixpkgs/blob/61235d44/nixos/lib/make-options-doc/default.nix#L128-L165
    ];
  };
}
