{inputs, ...}: {
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem = {
    pkgs,
    config,
    system,
    ...
  }: {
    devshells.default = {
      devshell.startup.pre-commit.text = config.pre-commit.installationScript;

      commands = let
        # Thanks to this, the user can choose to use `nix-output-monitor` (`nom`) instead of plain `nix`
        nix = "$([ '$\{NIXVIM_NOM:-0}' = '1' ] && echo ${pkgs.lib.getExe pkgs.nom} || echo nix)";
      in [
        {
          name = "checks";
          help = "Run all nixvim checks";
          command = "nix flake check";
        }
        {
          name = "tests";
          help = "Run nixvim tests";
          command = ''
            echo "=> Running nixvim tests for the '${system}' architecture..."

            ${nix} build .#checks.${system}.tests "$@"
          '';
        }
        {
          name = "format";
          help = "Format the entire codebase";
          command = "nix fmt";
        }
        {
          name = "docs";
          help = "Build nixvim documentation";
          command = ''
            echo "=> Building nixvim documentation..."

            ${nix} build .#docs "$@"
          '';
        }
        {
          name = "serve-docs";
          help = "Build and serve documentation locally";
          command = ''
            echo -e "=> Building nixvim documentation...\n"

            doc_derivation=$(${nix} build .#docs --no-link --print-out-paths)

            echo -e "\n=> Documentation succesfully built ('$doc_derivation')"

            port=8000
            echo -e "\n=> Now open your browser and navigate to 'localhost:$port'\n"

            ${pkgs.lib.getExe pkgs.python3} -m http.server -d "$doc_derivation"/share/doc
          '';
        }
      ];
    };
  };
}
