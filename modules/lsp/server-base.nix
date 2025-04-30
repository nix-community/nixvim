# Usage: lib.importApply ./server-base.nix { /*args*/ }
{
  displayName ? "the language server",
  settings ? null,
  enable ? null,
}:
{ lib, ... }:
let
  inherit (lib) types;
in
{
  options = {
    enable = lib.mkOption rec {
      type = types.bool;
      description = "Whether to enable ${enable.name or displayName}. ${enable.extraDescription or ""}";
      default = enable.default or false;
      example = enable.example or (!default);
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
