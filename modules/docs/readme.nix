{
  lib,
  fixLinks,
  runCommand,
  availableVersions ? [ ],
  baseHref ? "/", # TODO: remove & get from module config
}:
let
  # Zip the list of attrs into an attr of lists, for use as bash arrays
  zippedVersions =
    assert lib.assertMsg
      (lib.all (o: o ? branch && o ? nixpkgsBranch && o ? baseHref) availableVersions)
      "Expected all `availableVersions` docs entries to contain { branch, nixpkgsBranch, baseHref } attrs!";
    lib.zipAttrs availableVersions;
in
runCommand "index.md"
  {
    template = ../../docs/mdbook/index.md;

    readme =
      runCommand "readme"
        {
          start = "<!-- START DOCS -->";
          end = "<!-- STOP DOCS -->";
          src = fixLinks ../../README.md;
        }
        ''
          # extract relevant section of the README
          sed -n "/$start/,/$end/p" $src > $out
        '';

    docs_versions =
      runCommand "docs-versions"
        {
          __structuredAttrs = true;
          branches = zippedVersions.branch or [ ];
          nixpkgsBranches = zippedVersions.nixpkgsBranch or [ ];
          baseHrefs = zippedVersions.baseHref or [ ];
          current = baseHref;
        }
        ''
          touch "$out"
          for i in ''${!branches[@]}; do
            branch="''${branches[i]}"
            nixpkgs="''${nixpkgsBranches[i]}"
            baseHref="''${baseHrefs[i]}"
            linkText="\`$branch\` branch"

            link=
            suffix=
            if [ "$baseHref" = "$current" ]; then
              # Don't bother linking to ourselves
              link="$linkText"
              suffix=" _(this page)_"
            else
              link="[$linkText]($baseHref)"
            fi

            echo "- The $link, for use with nixpkgs \`$nixpkgs\`$suffix" >> "$out"
          done
          # link to beta-docs
          echo "- The [beta-docs](./beta), for use with "
        '';
  }
  ''
    substitute $template $out \
      --subst-var-by README "$(cat $readme)" \
      --subst-var-by DOCS_VERSIONS "$(cat $docs_versions)"
  ''
