{
  lib,
  runCommand,
  makeBinaryWrapper,
  python3,
  docs,
}:
runCommand "serve-docs"
  {
    nativeBuildInputs = [ makeBinaryWrapper ];
    meta.mainProgram = "server";
  }
  ''
    mkdir -p $out/bin
    makeWrapper ${lib.getExe python3} \
        $out/bin/server \
        --add-flags ${./server.py} \
        --chdir ${docs}
  ''
