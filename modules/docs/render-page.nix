{
  path,
  nixos-render-docs,
  runCommand,
  name,
  title,
  description ? "",
  optionsJSON,
  revision ? "",
}:
runCommand "page-${name}.md"
  {
    inherit
      title
      description
      optionsJSON
      revision
      ;

    # https://github.com/NixOS/nixpkgs/blob/master/doc/manpage-urls.json
    manpageUrls = path + "/doc/manpage-urls.json";

    nativeBuildInputs = [
      nixos-render-docs
    ];
  }
  ''
    nixos-render-docs -j $NIX_BUILD_CORES \
      options commonmark \
      --manpage-urls $manpageUrls \
      --revision "$revision" \
      --anchor-prefix opt- \
      --anchor-style legacy \
      $optionsJSON options.md

    (
      echo "# $title"
      echo
      echo "$description"
      echo
      cat options.md
    ) > $out
  ''
