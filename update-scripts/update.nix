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

    writeGitHubOutput() {
      if [ -n "$use_github_output" ]; then
        (
          echo "$1<<EOF"
          git show --no-patch --format=%b
          echo "EOF"
        ) >> "$GITHUB_OUTPUT"
      fi
    }

    versionInfo() {
      nix-build ./update-scripts -A version-info
      ./result/bin/version-info
      if [ -n "$commit" ]; then
        git add version-info.toml
        git commit "$@"
      fi
    }

    # Initialise version-info.toml
    if [ ! -f version-info.toml ]; then
      echo "Creating version-info file"
      versionInfo -m "version-info: init"
    fi

    # Update the root lockfile
    old=$(git show --no-patch --format=%h)
    echo "Updating root lockfile"
    nix flake update "''${update_args[@]}"
    new=$(git show --no-patch --format=%h)
    if [ "$old" != "$new" ]; then
      echo "Updating version-info"
      versionInfo --amend --no-edit
      writeGitHubOutput root_lock_body
    fi

    # Update the dev lockfile
    root_nixpkgs=$(nix eval --raw --file . 'inputs.nixpkgs.rev')
    old=$(git show --no-patch --format=%h)
    echo "Updating dev lockfile"
    nix flake update "''${update_args[@]}" \
        --override-input 'dev-nixpkgs' "github:NixOS/nixpkgs/$root_nixpkgs" \
        --flake './flake/dev'
    new=$(git show --no-patch --format=%h)
    if [ "$old" != "$new" ]; then
      echo "Updating version-info"
      versionInfo --amend --no-edit
      writeGitHubOutput dev_lock_body
    fi
  '';
}
