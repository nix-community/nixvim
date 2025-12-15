# Usage: lib.importApply ./server.nix { /*args*/ }
{
  name ? "the language server",
  package ? null,
  config ? null,
}@args:
let
  displayName = name;
  packageName = package.name or args.name or "language server";
in
{
  lib,
  name,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types;
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

    packageFallback = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        When enabled, the language server package will be added to the end of the `PATH` _(suffix)_ instead of the beginning _(prefix)_.

        This can be useful if you want local versions of the language server (e.g. from a devshell) to override the nixvim version.
      '';
    };

    packages.prefix = lib.mkOption {
      type = types.listOf types.package;
      description = "Packages to prefix onto the PATH.";
      default = [ ];
      visible = false;
      internal = true;
    };

    packages.suffix = lib.mkOption {
      type = types.listOf types.package;
      description = "Packages to suffix onto the PATH.";
      default = [ ];
      visible = false;
      internal = true;
    };

    config = lib.mkOption {
      type = with types; attrsOf anything;
      description = ''
        Configurations for ${displayName}. ${args.config.extraDescription or ""}
      '';
      default = { };
      example =
        args.config.example or {
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

  config = {
    packages = lib.mkIf (config.package != null) {
      ${if config.packageFallback then "suffix" else "prefix"} = [
        config.package
      ];
    };
  };

  imports = [
    ./server-renames.nix
  ]
  # We cannot use `config._module.args.name` in imports, since `config` causes inf-rec.
  # Therefore we can only import custom modules when we have an externally supplied `name`.
  ++ lib.optionals (args ? name) (
    lib.filter lib.pathExists [
      ./custom/${args.name}.nix
      ./custom/${args.name}/default.nix
    ]
  );
}
