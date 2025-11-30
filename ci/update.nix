{
  nix,
  writeShellApplication,
}:
writeShellApplication {
  name = "update";

  runtimeInputs = [
    nix
  ];

  text = ''
    commit=
    use_github_output=
    while [ $# -gt 0 ]; do
      case "$1" in
      --commit) commit=1
        ;;
      --github-output) use_github_output=1
        ;;
      --*) echo "unknown option $1"
        ;;
      *) echo "unexpected argument $1"
        ;;
      esac
      shift
    done

    # Ensure we run at the root of the flake
    cd "$(git rev-parse --show-toplevel)"

    workdir=$(mktemp -d -t update-XXXXXX)
    trap 'rm -rf "$workdir"' EXIT
    root_update="$workdir/root_update"
    dev_update="$workdir/dev_update"
    root_msg="$workdir/root_msg"
    dev_msg="$workdir/dev_msg"
    commit_msg="$workdir/commit_msg"

    cleanUpdateOutput() {
      awk --assign prefix="$PWD/" '
        # Find the start of the update info block
        /^warning: updating lock file "/ {
          if (match($0, /"([^"]+)"/, m)) {
            # Print the first line as `{path} updates:`
            path = m[1]
            sub("^" prefix, "", path)
            print path " updates:"

            # Mark that we have entered the update info block
            printing=1
          }
          next
        }

        # Print while in the update info block
        printing {
          if ($0 == "") exit
          print
        }
      ' "$1"
    }

    writeGitHubOutput() {
      if [ -n "$use_github_output" ]; then
        {
          echo "$1<<EOF"
          cat "$2"
          echo "EOF"
        } >> "$GITHUB_OUTPUT"
      fi
    }

    versionInfo() {
      echo "Updating version-info"
      "$(nix-build ./ci -A version-info --no-out-link)"/bin/version-info
    }

    # Initialise version-info.toml
    if [ ! -f version-info.toml ]; then
      echo "Creating version-info file"
      versionInfo
      if [ -n "$commit" ]; then
        git add version-info.toml
        git commit -m "version-info: init"
      fi
    fi

    # Commit message summary
    {
      # Avoid using impure global config from `nix config show commit-lock-file-summary`
      nix-instantiate --raw --eval flake.nix --attr nixConfig.commit-lock-file-summary 2>/dev/null \
      || echo -n "flake: Update"
      printf '\n'
    } >"$commit_msg"

    # Update the root lockfile
    echo "Updating root lockfile"
    nix flake update 2> >(tee "$root_update" >&2)
    cleanUpdateOutput "$root_update" > "$root_msg"
    if [ -s "$root_msg" ]; then
      {
        printf '\n'
        cat "$root_msg"
      } >>"$commit_msg"
      versionInfo
      writeGitHubOutput root_lock_body "$root_msg"
    fi

    # Update the dev lockfile
    root_nixpkgs=$(nix eval --raw --file . 'inputs.nixpkgs.rev')
    echo "Updating dev lockfile"
    nix flake update \
        --override-input 'dev-nixpkgs' "github:NixOS/nixpkgs/$root_nixpkgs" \
        --flake './flake/dev' \
        2> >(tee "$dev_update" >&2)
    cleanUpdateOutput "$dev_update" > "$dev_msg"
    if [ -s "$dev_msg" ]; then
      {
        printf '\n'
        cat "$dev_msg"
      } >>"$commit_msg"
      versionInfo
      writeGitHubOutput dev_lock_body "$dev_msg"
    fi

    # Only commit if at least one file has changes
    if git diff --quiet flake.lock flake/dev/flake.lock version-info.toml; then
      echo "Nothing to commit"
    elif [ -n "$commit" ]; then
      echo "Committing"
      git add flake.lock flake/dev/flake.lock version-info.toml
      git commit --file "$commit_msg"
    else
      echo "Would commit as (skipping):"
      cat "$commit_msg"
    fi
  '';
}
