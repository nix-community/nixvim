{ lib, inputs, ... }:
{
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem =
    {
      pkgs,
      config,
      self',
      system,
      ...
    }:
    {
      devshells.default = {
        devshell.startup.pre-commit.text = config.pre-commit.installationScript;

        devshell.packages = [
          config.formatter
        ];

        commands =
          let
            # Thanks to this, the user can choose to use `nix-output-monitor` (`nom`) instead of plain `nix`
            nix = ''$([ "$\{NIXVIM_NOM:-0}" = '1' ] && echo ${pkgs.lib.getExe pkgs.nix-output-monitor} || echo nix)'';
          in
          [
            {
              name = "checks";
              help = "Run all nixvim checks";
              # TODO: run tests from the `ci` flake output too?
              command = ''
                echo "=> Running all nixvim checks..."

                ${nix} flake check "$@"
              '';
            }
            {
              name = "tests";
              help = "Run nixvim tests";
              command =
                let
                  launchTest = pkgs.writeShellApplication {
                    name = "launch-tests";
                    runtimeInputs = with pkgs; [
                      getopt
                      jq
                      fzf
                    ];

                    text = builtins.readFile ./launch-test.sh;
                  };

                  tests =
                    let
                      checks' = self'.checks;
                      names = builtins.filter (n: builtins.match "test-.*" n != null) (builtins.attrNames checks');
                    in
                    builtins.listToAttrs (
                      builtins.concatMap (
                        checkName:
                        map (testName: {
                          name = testName;
                          value = "${checkName}.entries.${testName}";
                        }) (builtins.attrNames checks'.${checkName}.entries)
                      ) names
                    );
                in
                ''
                  export NIXVIM_SYSTEM=${system}
                  export NIXVIM_NIX_COMMAND=${nix}
                  export NIXVIM_TESTS=${pkgs.writers.writeJSON "tests.json" tests}
                  ${lib.getExe launchTest} "$@"
                '';
            }
            {
              name = "test-lib";
              help = "Run nixvim library tests";
              command = ''
                echo "=> Running nixvim library tests for the '${system}' architecture..."

                ${nix} build .#checks.${system}.lib-tests "$@"
              '';
            }
            {
              name = "format";
              help = "Format the entire codebase";
              command = lib.getExe config.formatter;
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
                nix run .#docs
              '';
            }
            {
              name = "locate-lsp-packages";
              command = ''${pkgs.python3.interpreter} ${./locate-lsp-packages.py}'';
              help = "Locate (with nix-index) LSP servers in nixpkgs";
            }
            {
              name = "new-plugin";
              command = ''${pkgs.python3.interpreter} ${./new-plugin.py} "$@"'';
              help = "Create a new plugin";
            }
            {
              name = "diff-plugins";
              command = ''${pkgs.python3.interpreter} ${./diff-plugins.py} "$@"'';
              help = "Compare available plugins with another nixvim commit";
            }
          ];
      };
    };
}
