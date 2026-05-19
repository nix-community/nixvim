{
  lib,
  self,
  jq,
  nix,
  linkFarmFromDrvs,
  runCommandLocal,
  writableTmpDirAsHomeHook,
}:

# nixpkgs.nix fetches our pinned nixpkgs using the `fetchTree` primop.
#
# In this file, we test that it is identical to our `inputs.nixpkgs` flake input.
#
# The primop is only available with `experimental-features = flakes` or `experimental-features = fetch-tree`,
# so we have a `fetchTree` polyfill that delegates to `fetchTarball`.
#
# Permutations to test:
# 1. fetchTree primop
#   a. attrs
#   b. outPath derivation
# 2. fetchTree polyfill
#   a. attrs
#   b. outPath derivation
#
# As we run this test from a flake, we have `experimental-features = flakes` and `fetchTree` primop is available.
# Therefore, we can test the `fetchTree` primop easily.
#
# By running `nix-instantiate` _within_ a build sandbox, we can configure `experimental-features =`
# to test the polyfill's attrs. However, we cannot do an actual fetch in the sandbox.
#
# Since we can't do an actual fetch in the sandbox, the polyfill's outPath can be tested manually.
# These should both evaluate to the same derivation:
#     nix-instantiate --eval nixpkgs.nix --attr outPath --option experimental-features flakes
#     nix-instantiate --eval nixpkgs.nix --attr outPath --option experimental-features ''

let
  flake-input = self.inputs.nixpkgs.sourceInfo;
  pinned-input = import ../nixpkgs.nix;
in
linkFarmFromDrvs "nixpkgs-fetch-test" [

  (runCommandLocal "nixpkgs-fetch-test-with-primop"
    {
      __structuredAttrs = true;
      unsafeDiscardReferences.out = true;
      strictDeps = true;

      hasPrimop = builtins ? fetchTree;
      expected = flake-input;
      actual = pinned-input;

      expectedAttrs = removeAttrs flake-input [ "outPath" ];
      actualAttrs = removeAttrs pinned-input [ "outPath" ];

      nativeBuildInputs = [
        jq
      ];
    }
    ''
      echo 'Sanity check that `fetchTree` is enabled'
      if [ -n "$hasPrimop" ]; then
        echo "fetchTree is available" >&2
      else
        echo "fetchTree is not available" >&2
        exit 1
      fi

      if [ "$expected" = "$actual" ]; then
        echo "Expectation met: '$expected'" >&2
      else
        echo "Expected '$actual' to be '$expected'" >&2
        exit 1
      fi

      mkdir "$out"
      jq --sort-keys .expectedAttrs "$NIX_ATTRS_JSON_FILE" > "$out/expected.json"
      jq --sort-keys .actualAttrs "$NIX_ATTRS_JSON_FILE" > "$out/actual.json"

      # Compare actual.json and expected.json
      if ! diff --unified "$out/expected.json" "$out/actual.json"; then
        echo 'Unexpected difference between `expected.json` and `actual.json`' >&2
        exit 1
      fi
    ''
  )

  (runCommandLocal "nixpkgs-fetch-test-with-polyfill"
    {
      __structuredAttrs = true;
      unsafeDiscardReferences.out = true;
      strictDeps = true;

      src = lib.fileset.toSource {
        root = ../.;
        fileset = lib.fileset.unions [
          ../flake.lock
          ../nixpkgs.nix
        ];
      };

      expectedAttrs = removeAttrs flake-input [ "outPath" ];

      nativeBuildInputs = [
        jq
        nix
        writableTmpDirAsHomeHook
      ];
    }
    ''
      # Setup nix environment
      export TEST_ROOT="$PWD/test-tmp"
      export NIX_CONF_DIR="$TEST_ROOT/etc"
      export NIX_LOCALSTATE_DIR="$TEST_ROOT/var"
      export NIX_LOG_DIR="$TEST_ROOT/var/log/nix"
      export NIX_STATE_DIR="$TEST_ROOT/var/nix"
      export PAGER=cat

      mkdir -p "$NIX_CONF_DIR"
      cat > "$NIX_CONF_DIR/nix.conf" <<EOF
      store = dummy://
      experimental-features =
      EOF

      echo 'Sanity check that `fetchTree` is disabled'
      echo "NOTE: if this assertion fails, then 'fetch-tree' may no longer be an experimental feature"
      nix-instantiate --eval --raw --expr '
        if builtins ? fetchTree then
          throw "fetchTree is available"
        else
          "fetchTree is not available\n"
      '

      mkdir "$out"

      echo "Evaluating expected"
      jq --sort-keys .expectedAttrs "$NIX_ATTRS_JSON_FILE" > "$out/expected.json"

      echo "Evaluating actual"
      nix-instantiate --eval --strict --json \
        --argstr actual "$src/nixpkgs.nix" \
        --expr '{ actual }: removeAttrs (import actual) [ "outPath" ]' \
        | jq --sort-keys . > "$out/actual.json"

      # Compare actual.json and expected.json
      if ! diff --unified "$out/expected.json" "$out/actual.json"; then
        echo 'Unexpected difference between `expected.json` and `actual.json`' >&2
        exit 1
      fi
    ''
  )

]
