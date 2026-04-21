{
  lib,
  nix,
  pipeOperatorFlag,
  runCommand,
}:
runCommand "nix-parse-${nix.name}"
  {
    nativeBuildInputs = [ nix ];
    nixvim =
      with lib.fileset;
      toSource {
        root = ../.;
        fileset = fileFilter (file: file.hasExt "nix") ../.;
      };
    inherit pipeOperatorFlag;
  }
  ''
    export HOME="$TMPDIR"
    export XDG_CONFIG_HOME="$TMPDIR"
    export NIX_CONF_DIR="$TMPDIR/nix-conf"
    parseLog="$TMPDIR/nix-parse.log"
    mkdir -p "$NIX_CONF_DIR"
    : > "$NIX_CONF_DIR/nix.conf"

    export NIX_STORE_DIR="$TMPDIR/store"
    export NIX_STATE_DIR="$TMPDIR/state"
    nix-store --init

    cd "$nixvim"

    # This will only show the first parse error, not all of them.
    # That's fine, because the other CI jobs will report in more detail.
    # This job is about checking parsing across different
    # implementations / versions, not about providing the best DX.
    # Returning all parse errors requires significantly more resources.
    if ! find . -type f -iname '*.nix' -print0 | xargs -0 -P "$(nproc)" nix-instantiate --extra-experimental-features "$pipeOperatorFlag" --parse > /dev/null 2> "$parseLog"; then
      cat "$parseLog" >&2
      echo "Parse failed in nix-instantiate." >&2
      exit 1
    fi

    if grep -q "^warning:" "$parseLog"; then
      cat "$parseLog" >&2
      echo "Failing due to warnings in stderr" >&2
      exit 1
    fi

    touch "$out"
  ''
