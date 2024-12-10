{
  pkgs,
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "nixvim-init";
  version = "nightly";

  src = ./.;

  cargoHash = "sha256-Y4Y5nNfYhfj80+DeCwjee0nRBctO1M9dJ0DwhGfkdF0=";

  meta.mainProgram = "nixvim-init";
}
