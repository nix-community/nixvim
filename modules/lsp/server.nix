# Usage: lib.importApply ./server.nix { /*args*/ }
{
  name ? null,
  package ? null,
  settings ? null,
  pkgs ? { },
}@args:
{ lib, name, ... }:
let
  inherit (lib) types;
  displayName = args.name or "the language server";
  packageName = package.name or (lib.strings.removePrefix "the " displayName);
in
{
  options = {
    enable = lib.mkEnableOption displayName;

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
      default = true;
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

    settings = lib.mkOption {
      type = with types; attrsOf anything;
      description = ''
        Configurations for ${displayName}. ${settings.extraDescription or ""}
      '';
      default = { };
      example =
        settings.example or {
          cmd = [
            "clangd"
            "--background-index"
          ];
          root_markers = [
            "compile_commands.json"
            "compile_flags.txt"
          ];
          filetypes = [
            "c"
            "cpp"
          ];
        };
    };

    # NOTE: we need a warnings option for `mkRenamedOptionModule` to warn about unexpected definitions
    # This can be removed when all rename aliases are gone
    warnings = lib.mkOption {
      type = with types; listOf str;
      description = "Warnings to propagate to nixvim's `warnings` option.";
      default = [ ];
      internal = true;
      visible = false;
    };
  };

  imports = [
    # TODO: rename added 2025-04-30 (during the 25.05 cycle)
    # The previous name `config` was introduced 2025-04-28 (during the 25.05 cycle)
    # Because the previous name `config` never made it into a stable release,
    # we could consider dropping this alias sooner than normal.
    (lib.mkRenamedOptionModule [ "config" ] [ "settings" ])
  ];
}
