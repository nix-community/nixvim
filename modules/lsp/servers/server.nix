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

    __internalCapabilities = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      description = ''
        This internal option exists to preserve the old `plugins.lsp.servers.*.capabilities` behaviour.
        It should be non-null when the old system is needed.

        Any lines of lua will be able to mutate a table named `capabilities`.

        > [!IMPORTANT]
        > This option should not be defined by end-users!
      '';
      internal = true;
      visible = false;
    };
  };

  imports = [
    ./server-renames.nix
  ];
}
