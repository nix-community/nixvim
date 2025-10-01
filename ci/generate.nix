{
  writeShellApplication,
  rust-analyzer-options,
  efmls-configs-sources,
  none-ls-builtins,
  lspconfig-servers,
  conform-formatters,
  nixfmt,
  nodePackages,
}:
writeShellApplication {
  name = "generate";

  runtimeInputs = [
    nixfmt
    nodePackages.prettier
  ];

  text = ''
    repo_root=$(git rev-parse --show-toplevel)
    generated_dir=$repo_root/generated

    commit=
    while [ $# -gt 0 ]; do
      case "$1" in
      --commit) commit=1
        ;;
      --*) echo "unknown option $1"
        ;;
      *) echo "unexpected argument $1"
        ;;
      esac
      shift
    done

    generate_nix() {
      echo "$2"
      cp "$1" "$generated_dir/$2.nix"
      nixfmt "$generated_dir/$2.nix"
    }

    generate_json() {
      echo "$2"
      prettier --parser=json "$1" >"$generated_dir/$2.json"
    }

    mkdir -p "$generated_dir"
    generate_nix "${rust-analyzer-options}" "rust-analyzer"
    generate_nix "${efmls-configs-sources}" "efmls-configs"
    generate_nix "${none-ls-builtins}" "none-ls"

    generate_json "${conform-formatters}" "conform-formatters"
    generate_json "${lspconfig-servers}" "lspconfig-servers"
    generate_json "${lspconfig-servers.unsupported}" "unsupported-lspconfig-servers"

    if [ -n "$commit" ]; then
      cd "$generated_dir"
      git add .

      # Construct a msg body from `git status -- .`
      body=$(
        git status \
          --short \
          --ignored=no \
          --untracked-files=no \
          --no-ahead-behind \
          -- . \
        | sed \
          -e 's/^\s*\([A-Z]\)\s*/\1 /' \
          -e 's/^A/Added/' \
          -e 's/^M/Updated/' \
          -e 's/^R/Renamed/' \
          -e 's/^D/Removed/' \
          -e 's/^/- /'
      )

      # Construct the commit message based on the body
      # NOTE: Can't use `wc -l` due to how `echo` pipes its output
      count=$(echo -n "$body" | awk 'END {print NR}')
      if [ "$count" -gt 1 ] || [ ''${#body} -gt 50 ]; then
        msg=$(echo -e "generated: Update\n\n$body")
      else
        msg="generated:''${body:1}"
      fi

      # Commit if there are changes
      if [ "$count" -gt 0 ]; then
        echo "Committing $count changes..."
        echo "$msg"
        git commit -m "$msg" --no-verify
      fi
    fi
  '';
}
