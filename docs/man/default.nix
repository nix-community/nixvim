{
  options-json,
  runCommand,
  installShellFiles,
  nixos-render-docs,
  pandoc,
}:
let
  manualFilter = ''
    local text = pandoc.text

    function Header(el)
        if el.level == 1 then
          return el:walk {
            Str = function(el)
                return pandoc.Str(text.upper(el.text))
            end
          }
        end
    end

    function Link(el)
      return el.content
    end
  '';

  manHeader =
    let
      mkMDSection = file: "<(pandoc --lua-filter <(echo \"$manualFilter\") -f gfm -t man ${file})";
    in
    runCommand "nixvim-general-doc-manpage"
      {
        nativeBuildInputs = [ pandoc ];
        inherit manualFilter;
      }
      ''
        mkdir -p $out
        cat \
          ${./nixvim-header-start.5} \
          ${mkMDSection ../user-guide/helpers.md} \
          ${mkMDSection ../user-guide/faq.md} \
          ${./nixvim-header-end.5} \
          >$out/nixvim-header.5
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
