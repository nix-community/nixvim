# Usage: lib.importApply ./server.nix { /*args*/ }
{
  name ? "the language server",
  package ? null,
  settings ? null,
  pkgs ? { },
}@args:
{
  lib,
  name,
  config,
  ...
}:
let
  inherit (lib) types;
  displayName = args.name or "the language server";
  packageName = package.name or (lib.strings.removePrefix "the " displayName);
in
{
  options = {
    name = lib.mkOption {
      type = types.maybeRaw types.str;
      description = ''
        The name to use for ${displayName}.
        Supplied to functions like `vim.lsp.enable()`.
      '';
      # Use the supplied attr name, or fallback to the name module-arg
      default = args.name or name;
      defaultText = args.name or (lib.literalMD "the attribute name");
    };

    activate = lib.mkOption {
      type = types.bool;
      description = ''
        Whether to call `vim.lsp.enable()` for ${displayName}.
      '';
      default = config.name != "*";
      defaultText = lib.literalMD ''
        `true`, unless the server's `name` is `*`
      '';
      example = false;
    };

    package = lib.mkPackageOption pkgs packageName {
      nullable = true;
      default = package.default or package;
      example = package.example or null;
      extraDescription = ''
        ${package.extraDescription or ""}

        Alternatively, ${displayName} should be installed on your `$PATH`.
      '';
    };
  };

  imports = [
    (lib.modules.importApply ./server-base.nix {
      inherit displayName settings;
    })
  ];
}
