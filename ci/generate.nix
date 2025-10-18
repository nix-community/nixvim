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

    generate_json() {
      # Get file part from filepath and remove hash prefix
      output_name=$(basename "$1" | cut -d "-" -f "2-")
      basename "$1" ".json"
      prettier "$1" > "$generated_dir/$output_name"
    }

    mkdir -p "$generated_dir"

    generate_json "${rust-analyzer-options}"
    generate_json "${efmls-configs-sources}"
    generate_json "${none-ls-builtins}"
    generate_json "${conform-formatters}"
    generate_json "${lspconfig-servers}"
    generate_json "${lspconfig-servers.unsupported}"

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
