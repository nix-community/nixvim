{
  lib,
  options-json,
  lib-docs,
  runCommand,
  installShellFiles,
  nixos-render-docs,
  pandoc,
}:
let
  markdownSections = [
    ../user-guide/faq.md
    ../user-guide/config-examples.md
  ]
  ++ lib.mapAttrsToList (name: file: "${lib-docs}/${file}") lib-docs.pages;
  manHeader =
    runCommand "nixvim-general-doc-manpage"
      {
        nativeBuildInputs = [ pandoc ];
      }
      ''
        function mkMDSection {
          file="$1"
          pandoc --lua-filter ${./filter.lua} -f gfm -t man "$file"
        }
        mkdir -p $out

        (
          cat ${./nixvim-header-start.5}

          ${lib.concatMapStringsSep "\n" (file: "mkMDSection ${file}") markdownSections}

          cat ${./nixvim-header-end.5}
        ) >$out/nixvim-header.5
      '';
in
# FIXME add platform specific docs to manpage
runCommand "nixvim-configuration-reference-manpage"
  {
    nativeBuildInputs = [
      installShellFiles
      nixos-render-docs
    ];
  }
  ''
    # Generate man-pages
    mkdir -p $out/share/man/man5
    nixos-render-docs -j $NIX_BUILD_CORES options manpage \
      --revision unstable \
      --header ${manHeader}/nixvim-header.5 \
      --footer ${./nixvim-footer.5} \
      ${options-json}/share/doc/nixos/options.json \
      $out/share/man/man5/nixvim.5
    compressManPages $out
  ''
