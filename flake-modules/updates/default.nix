{
  perSystem =
    { pkgs, ... }:
    {
      apps.generate-files.program = pkgs.writeShellApplication {
        name = "generate-files";

        text = ''
          repo_root=$(git rev-parse --show-toplevel)
          generated_dir=$repo_root/generated

          echo "Rust-Analyzer"
          nix build .#rust-analyzer-options
          cat ./result >"$generated_dir"/rust-analyzer.nix

          echo "efmls-configs"
          nix build .#efmls-configs-sources
          cat ./result >"$generated_dir"/efmls-configs.nix

          echo "none-ls"
          nix build .#none-ls-builtins
          cat ./result >"$generated_dir"/none-ls.nix

          nix fmt
        '';
      };

      packages = {
        rust-analyzer-options = pkgs.callPackage ./rust-analyzer.nix { };
        efmls-configs-sources = pkgs.callPackage ./efmls-configs.nix { };
        none-ls-builtins = pkgs.callPackage ./none-ls.nix { };
      };
    };
}
