{
  docs,
  http-server,
  writeShellApplication,
}:
writeShellApplication {
  name = "serve-docs";
  runtimeInputs = [ http-server ];
  runtimeEnv.server_flags = [
    # Search for available port
    "--port=0"

    # Disable browser cache
    "-c-1"

    # Open using xdg-open
    "-o"
  ];
  text = ''
    http-server ${docs} "''${server_flags[@]}"
  '';
}
