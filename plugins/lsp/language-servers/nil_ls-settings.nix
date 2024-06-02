{ lib, helpers }:
# Options:
#  - https://github.com/oxalica/nil/blob/main/docs/configuration.md?plain=1#
with lib;
{
  formatting = {
    command = helpers.defaultNullOpts.mkListOf types.str null ''
      External formatter command (with arguments).
      It should accepts file content in stdin and print the formatted code into stdout.
    '';
  };

  diagnostics = {
    ignored = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      Ignored diagnostic kinds.
      The kind identifier is a snake_cased_string usually shown together
      with the diagnostic message.
    '';

    excludedFiles = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      Files to exclude from showing diagnostics. Useful for generated files.
      It accepts an array of paths. Relative paths are joint to the workspace root.
      Glob patterns are currently not supported.
    '';
  };

  nix = {
    binary = helpers.defaultNullOpts.mkStr "nix" ''
      The path to the `nix` binary.
    '';

    maxMemoryMB = helpers.defaultNullOpts.mkInt 2560 ''
      The heap memory limit in MiB for `nix` evaluation.
      Currently it only applies to flake evaluation when `autoEvalInputs` is enabled, and only works
      for Linux.
      Other `nix` invocations may be also applied in the future.
      `null` means no limit.
      As a reference, `nix flake show --legacy nixpkgs` usually requires about 2GiB memory.
    '';

    flake = {
      autoArchive = helpers.defaultNullOpts.mkBool false ''
        Auto-archiving behavior which may use network.
         - `null`: Ask every time.
         - `true`: Automatically run `nix flake archive` when necessary.
         - `false`: Do not archive. Only load inputs that are already on disk.
      '';

      autoEvalInputs = helpers.defaultNullOpts.mkBool false ''
        Whether to auto-eval flake inputs.
        The evaluation result is used to improve completion, but may cost lots of time and/or memory.
      '';

      nixpkgsInputName = helpers.defaultNullOpts.mkStr "nixpkgs" ''
        The input name of nixpkgs for NixOS options evaluation.

        The options hierarchy is used to improve completion, but may cost lots of time and/or memory.
        If this value is `null` or is not found in the workspace flake's inputs, NixOS options are
        not evaluated.
      '';
    };
  };
}
