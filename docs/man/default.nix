{
  options-json,
  runCommand,
  installShellFiles,
  nixos-render-docs,
}:
runCommand "nixvim-configuration-reference-manpage" {
  nativeBuildInputs = [installShellFiles nixos-render-docs];
} ''
  # Generate man-pages
  mkdir -p $out/share/man/man5
  nixos-render-docs -j $NIX_BUILD_CORES options manpage \
    --revision unstable \
    --header ${./nixvim-header.5} \
    --footer ${./nixvim-footer.5} \
    ${options-json}/share/doc/nixos/options.json \
    $out/share/man/man5/nixvim.5
  compressManPages $out
''
