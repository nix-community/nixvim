{
  options-json,
  lib-docs,
  runCommand,
  installShellFiles,
  nixos-render-docs,
  pandoc,
}:
let
  manHeader =
    runCommand "nixvim-general-doc-manpage"
      {
        __structuredAttrs = true;
        strictDeps = true;
        nativeBuildInputs = [ pandoc ];
        markdownSections = [
          ../user-guide/faq.md
          ../user-guide/config-examples.md
        ]
        ++ lib-docs.pages;
      }
      ''
        mkdir -p $out
        {
          cat ${./nixvim-header-start.5}

          for file in "''${markdownSections[@]}"; do
            pandoc --lua-filter ${./filter.lua} -f gfm -t man "$file"
          done

          cat ${./nixvim-header-end.5}
        } >$out/nixvim-header.5
      '';
in
# FIXME add platform specific docs to manpage
runCommand "nixvim-configuration-reference-manpage"
  {
    __structuredAttrs = true;
    strictDeps = true;
    nativeBuildInputs = [
      installShellFiles
      nixos-render-docs
    ];
    header = manHeader;
    footer = ./nixvim-footer.5;
  }
  ''
    # Generate man-pages
    mkdir -p $out/share/man/man5
    nixos-render-docs -j $NIX_BUILD_CORES options manpage \
      --revision unstable \
      --header "$header"/nixvim-header.5 \
      --footer "$footer" \
      ${options-json}/share/doc/nixos/options.json \
      $out/share/man/man5/nixvim.5
    compressManPages $out
  ''
