# Usage: lib.importApply ./server.nix { /*args*/ }
{
  name ? "the language server",
  package ? null,
  cfg ? null,
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

    packageFallback = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        When enabled, the language server package will be added to the end of the `PATH` _(suffix)_ instead of the beginning _(prefix)_.

        This can be useful if you want local versions of the language server (e.g. from a devshell) to override the nixvim version.
      '';
    };

    cfg = lib.mkOption {
      type = with types; attrsOf anything;
      description = ''
        Configurations for ${displayName}. ${cfg.extraDescription or ""}
      '';
      default = { };
      example =
        cfg.example or {
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
  };

  imports = [
    ./server-renames.nix
  ];
}
