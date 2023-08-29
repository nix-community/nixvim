{
  stdenv,
  python3,
  vimPlugins,
}: let
  extract = stdenv.mkDerivation {
    pname = "extract_efmls_tools";
    version = "1";

    src = ./extract.py;

    dontUnpack = true;
    dontBuild = true;

    buildInputs = [python3];

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/extract_efmls_tools.py
    '';
  };
in
  stdenv.mkDerivation {
    pname = "efmls-configs-tools";
    inherit (vimPlugins.efmls-configs-nvim) version src;

    nativeBuildInputs = [extract];

    buildPhase = ''
      extract_efmls_tools.py ./lua/efmls-configs > efmls-configs-tools.json
    '';

    installPhase = ''
      mkdir -p $out/share
      cp efmls-configs-tools.json $out/share
    '';
  }
