{
  stdenv,
  python3,
  rust-analyzer,
  alejandra,
}: let
  extract = stdenv.mkDerivation {
    pname = "extract_rust_analyzer";
    version = "1";

    src = ./extract.py;

    dontUnpack = true;
    dontBuild = true;

    buildInputs = [python3];

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/extract_rust_analyzer.py
    '';
  };
in
  stdenv.mkDerivation {
    pname = "rust-analyzer-config";
    inherit (rust-analyzer) version src;

    nativeBuildInputs = [alejandra extract];

    buildPhase = ''
      extract_rust_analyzer.py editors/code/package.json |
        alejandra --quiet > rust-analyzer-config.nix
    '';

    installPhase = ''
      mkdir -p $out/share
      cp rust-analyzer-config.nix $out/share
    '';
  }
