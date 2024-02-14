{
  options-json,
  runCommand,
  installShellFiles,
  nixos-render-docs,
  pandoc,
}: let
  capitalizeHeaders = ''
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
  '';

  manHeader =
    runCommand "nixvim-general-doc-manpage" {
      nativeBuildInputs = [pandoc];
      inherit capitalizeHeaders;
    } ''
      mkdir -p $out
      cat \
        ${./nixvim-header-start.5} \
        <(pandoc --lua-filter <(echo "$capitalizeHeaders") -f gfm -t man ${../helpers.md}) \
        ${./nixvim-header-end.5} \
        >$out/nixvim-header.5
    '';
in
  runCommand "nixvim-configuration-reference-manpage" {
    nativeBuildInputs = [installShellFiles nixos-render-docs];
  } ''
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
