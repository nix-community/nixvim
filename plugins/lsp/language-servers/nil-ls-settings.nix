{ lib, ... }:
# All available settings are documented here:
# https://github.com/oxalica/nil/blob/main/docs/configuration.md
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
{
  formatting = {
    command = defaultNullOpts.mkListOf' {
      type = types.str;
      pluginDefault = null;
      description = ''
        External formatting command, complete with required arguments.

        It should accept file content from stdin and print the formatted code to stdout.
      '';
      example = [ "nixpkgs-fmt" ];
    };
  };

  diagnostics = {
    ignored = defaultNullOpts.mkListOf types.str [ ] ''
      Ignored diagnostic kinds.
      The kind identifier is a snake_cased_string usually shown together
      with the diagnostic message.
    '';

    excludedFiles = defaultNullOpts.mkListOf' {
      type = types.str;
      pluginDefault = [ ];
      description = ''
        Files to exclude from showing diagnostics. Useful for generated files.

        It accepts an array of paths. Relative paths are joint to the workspace root.
        Glob patterns are currently not supported.
      '';
      example = [ "Cargo.nix" ];
    };
  };

  nix = {
    binary = defaultNullOpts.mkStr' {
      pluginDefault = "nix";
      description = "The path to the `nix` binary.";
      example = "/run/current-system/sw/bin/nix";
    };

    maxMemoryMB = defaultNullOpts.mkUnsignedInt' {
      pluginDefault = 2560;
      example = 1024;
      description = ''
        The heap memory limit in MiB for `nix` evaluation.

        Currently it only applies to flake evaluation when `autoEvalInputs` is enabled, and only works
        for Linux.
        Other `nix` invocations may be also applied in the future.
        `null` means no limit.

        As a reference, `nix flake show --legacy nixpkgs` usually requires about 2GiB memory.
      '';
    };

    flake = {
      autoArchive = defaultNullOpts.mkBool false ''
        Auto-archiving behavior which may use network.
         - `null`: Ask every time.
         - `true`: Automatically run `nix flake archive` when necessary.
         - `false`: Do not archive. Only load inputs that are already on disk.
      '';

      autoEvalInputs = defaultNullOpts.mkBool false ''
        Whether to auto-eval flake inputs.
        The evaluation result is used to improve completion, but may cost lots of time and/or memory.
      '';

      nixpkgsInputName = defaultNullOpts.mkStr' {
        pluginDefault = "nixpkgs";
        example = "nixos";
        description = ''
          The input name of nixpkgs for NixOS options evaluation.

          The options hierarchy is used to improve completion, but may cost lots of time and/or memory.

          If this value is `null` or is not found in the workspace flake's inputs, NixOS options are
          not evaluated.
        '';
      };
    };
  };
}
