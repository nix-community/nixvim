{
  lib,
  flake,
}:
let
  inherit (builtins)
    isList
    mapAttrs
    head
    tail
    ;

  lockFile = lib.importJSON ../flake.lock;

  /**
    Resolve an input spec into a node name.

    # Inputs

    `inputSpec` ([String] | String)
    : Either a node name, or a "follows" path relative to the root node.

    # Output

    The node name.

    # Upstream

    This is based on `resolveInput` in nix's [call-flake.nix]

    [call-flake.nix]: https://github.com/NixOS/nix/blob/46beb9af/src/libflake/call-flake.nix#L21-L25
  */
  resolveInput =
    inputSpec: if isList inputSpec then getInputByPath lockFile.root inputSpec else inputSpec;

  /**
    Follow an input attrpath from the root node, stepping through each node along the path.

    # Inputs

    `nodeName`
    : The name of the _current_ node.

    `path`
    : The input attrpath to follow.
      E.g. `["dwarffs" "nixpkgs"]`

    # Outputs

    The final node name.

    # Upstream

    This is based on `getInputByPath` in nix's [call-flake.nix]

    [call-flake.nix]: https://github.com/NixOS/nix/blob/46beb9af/src/libflake/call-flake.nix#L27-L37
  */
  getInputByPath =
    nodeName: path:
    if path == [ ] then
      nodeName
    else
      getInputByPath (resolveInput lockFile.nodes.${nodeName}.inputs.${head path}) (tail path);

  # Inputs specified in our flake.lock
  lockedInputs = lib.pipe lockFile.nodes.${lockFile.root}.inputs [
    (mapAttrs (inputName: inputSpec: lockFile.nodes.${resolveInput inputSpec}))
  ];

  # Our actual inputs, potentially modified by end-user's "follows"
  realInputs = flake.inputs;
in
{
  /**
    Check whether a specific input is modified when compared to our `flake.lock` file.

    This can happen when a user specifies one of our inputs "follows" one of theirs.
  */
  isInputModified =
    name:
    assert lib.assertMsg (
      realInputs ? ${name}
    ) "isInputModified: `${lib.strings.escapeNixIdentifier name}` is not in `inputs`.";
    assert lib.assertMsg (
      lockedInputs ? ${name}
    ) "isInputModified: `${lib.strings.escapeNixIdentifier name}` is not in `flake.lock`.";
    let
      # If a non-flake input is used, `sourceInfo` will be missing
      real = realInputs.${name}.sourceInfo.narHash or null;
      locked = lockedInputs.${name}.locked.narHash;
    in
    real != locked;
}
