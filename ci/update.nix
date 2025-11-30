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

    update_args=( )
    if [ -n "$commit" ]; then
      update_args+=( "--commit-lock-file" )
    fi

    # Ensure we run at the root of the flake
    cd "$(git rev-parse --show-toplevel)"

    currentCommit() {
      git show --no-patch --format=%h
    }

    hasChanges() {
      old="$1"
      new="$2"
      if [ -n "$commit" ]; then
        [ "$old" != "$new" ]
      elif git diff --quiet; then
        return 1
      else
        return 0
      fi
    }

    writeGitHubOutput() {
      if [ -n "$use_github_output" ] && [ -n "$commit" ]; then
        {
          echo "$1<<EOF"
          git show --no-patch --format=%b
          echo "EOF"
        } >> "$GITHUB_OUTPUT"
      fi
    }

    versionInfo() {
      extra_args=( )
      if [ "$1" = "--amend" ]; then
        extra_args+=(
          "--amend"
          "--no-edit"
        )
      fi

      "$(nix-build ./ci -A version-info --no-out-link)"/bin/version-info

      if [ -n "$commit" ]; then
        git add version-info.toml
        git commit "''${extra_args[@]}"
      fi
    }

    # Initialise version-info.toml
    if [ ! -f version-info.toml ]; then
      echo "Creating version-info file"
      versionInfo -m "version-info: init"
    fi

    # Update the root lockfile
    old=$(currentCommit)
    echo "Updating root lockfile"
    nix flake update "''${update_args[@]}"
    new=$(currentCommit)
    if hasChanges "$old" "$new"; then
      echo "Updating version-info"
      versionInfo --amend
      writeGitHubOutput root_lock_body
    fi

    # Update the dev lockfile
    root_nixpkgs=$(nix eval --raw --file . 'inputs.nixpkgs.rev')
    old=$(currentCommit)
    echo "Updating dev lockfile"
    nix flake update "''${update_args[@]}" \
        --override-input 'dev-nixpkgs' "github:NixOS/nixpkgs/$root_nixpkgs" \
        --flake './flake/dev'
    new=$(currentCommit)
    if hasChanges "$old" "$new"; then
      echo "Updating version-info"
      versionInfo --amend
      writeGitHubOutput dev_lock_body
    fi
  '';
}
