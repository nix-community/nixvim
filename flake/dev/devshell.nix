{ lib, inputs, ... }:
{
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem =
    {
      pkgs,
      config,
      system,
      ...
    }:
    {
      devshells.default = {
        devshell.startup.pre-commit.text = config.pre-commit.installationScript;

        devshell.packages = [
          config.formatter
        ];

        env = [
          {
            # Prefix NIX_PATH with nixvim's nixpkgs while in the devshell
            name = "NIX_PATH";
            eval = "nixpkgs=$NIXPKGS_PATH:\${NIX_PATH:-}";
          }
        ];

        commands =
          let
            # Thanks to this, the user can choose to use `nix-output-monitor` (`nom`) instead of plain `nix`
            nix = ''$([ "$\{NIXVIM_NOM:-0}" = '1' ] && echo ${pkgs.lib.getExe pkgs.nix-output-monitor} || echo nix)'';
          in
          [
            {
              name = "checks";
              help = "Run all Nixvim checks";
              # TODO: run tests from the `ci` flake output too?
              command = ''
                echo "=> Running all Nixvim checks..."

                ${nix} flake check "$@"
              '';
            }
            {
              name = "tests";
              help = "Run Nixvim tests";
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
                in
                ''
                  export NIXVIM_SYSTEM=${system}
                  export NIXVIM_NIX_COMMAND=${nix}
                  ${lib.getExe launchTest} "$@"
                '';
            }
            {
              name = "test-lib";
              help = "Run Nixvim library tests";
              command = ''
                echo "=> Running Nixvim library tests for the '${system}' architecture..."

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
              help = "Build Nixvim documentation";
              command = ''
                echo "=> Building Nixvim documentation..."

                ${nix} build .#docs "$@"
              '';
            }
            {
              name = "serve-docs";
              help = "Build and serve documentation locally";
              command = ''
                echo -e "=> Building Nixvim documentation...\n"
                nix run .#docs
              '';
            }
            {
              name = "new-plugin";
              command = ''${./new-plugin.py} "$@"'';
              help = "Create a new plugin";
            }
            {
              name = "diff-plugins";
              command = ''${./diff-plugins.py} "$@"'';
              help = "Compare available plugins with another Nixvim commit";
            }
          ];
      };
    };
}
