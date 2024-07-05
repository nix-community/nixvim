{
  perSystem =
    { pkgs, ... }:
    {
      apps.generate-files.program = pkgs.writeShellApplication {
        name = "generate-files";

        text = ''
          repo_root=$(git rev-parse --show-toplevel)
          generated_dir=$repo_root/generated

          # Rust-Analyzer
          nix build .#rust-analyzer-options
          cat ./result >"$generated_dir"/rust-analyzer.nix

          nix fmt
        '';
      };

      packages = {
        rust-analyzer-options = pkgs.callPackage ./rust-analyzer.nix { };
      };
    };
}
