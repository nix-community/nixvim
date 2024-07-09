{
  perSystem =
    { pkgs, ... }:
    {
      apps.generate-files.program = pkgs.writeShellApplication {
        name = "generate-files";

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

          mkdir -p "$generated_dir"

          echo "Rust-Analyzer"
          nix build .#rust-analyzer-options
          cat ./result >"$generated_dir"/rust-analyzer.nix

          echo "efmls-configs"
          nix build .#efmls-configs-sources
          cat ./result >"$generated_dir"/efmls-configs.nix

          echo "none-ls"
          nix build .#none-ls-builtins
          cat ./result >"$generated_dir"/none-ls.nix

          git add --intent-to-add "$generated_dir"
          nix fmt

          if [ -n "$commit" ]; then
            cd "$generated_dir"
            git add .

            # Construct a msg body from `git status`
            body=$(
              git status \
                --short \
                --ignored=no \
                --untracked-files=no \
                --no-ahead-behind \
              | sed \
                -e 's/^\s*\([A-Z]\)\s*/\1 /' \
                -e 's/^A/Added/' \
                -e 's/^M/Updated/' \
                -e 's/^R/Renamed/' \
                -e 's/^D/Removed/' \
                -e 's/^/- /'
            )

            # Construct the commit message based on the body
            count=$(echo "$body" | wc -l)
            if [ "$count" -gt 1 ] || [ ''${#body} -gt 50 ]; then
              msg=$(echo -e "generated: Update\n\n$body")
            else
              msg="generated:''${body:1}"
            fi

            # Commit if there are changes
            [ "$count" -gt 0 ] && git commit -m "$msg" --no-verify
          fi
        '';
      };

      packages = {
        rust-analyzer-options = pkgs.callPackage ./rust-analyzer.nix { };
        efmls-configs-sources = pkgs.callPackage ./efmls-configs.nix { };
        none-ls-builtins = pkgs.callPackage ./none-ls.nix { };
      };
    };
}
