# Generates the documentation for library functions using nixdoc.
# See https://github.com/nix-community/nixdoc
{
  lib,
  runCommand,
  writers,
  nixdoc,
  nixvim,
  pageSpecs ? import ./pages.nix,
}:

let
  # Some pages are just menu entries, others have an actual markdown page that
  # needs rendering.
  shouldRenderPage = page: page ? file || page ? markdown;

  # Normalise a page node, recursively normalise its children
  elaboratePage =
    loc:
    {
      title ? "",
      markdown ? null,
      file ? null,
      pages ? { },
    }@page:
    {
      name = lib.attrsets.showAttrPath loc;
      loc = lib.throwIfNot (
        builtins.head loc == "lib"
      ) "All pages must be within `lib`, unexpected root `${builtins.head loc}`" (builtins.tail loc);
    }
    // lib.optionalAttrs (shouldRenderPage page) {
      inherit
        file
        title
        ;
      markdown =
        if builtins.isString markdown then
          builtins.toFile "${lib.strings.replaceStrings [ "/" "-" ] (lib.lists.last loc)}.md" markdown
        else
          markdown;
      outFile = lib.strings.concatStringsSep "/" (loc ++ [ "index.md" ]);
    }
    // lib.optionalAttrs (page ? pages) {
      pages = elaboratePages loc pages;
    };

  # Recursively normalise page nodes
  elaboratePages = prefix: builtins.mapAttrs (name: elaboratePage (prefix ++ [ name ]));

  # Collect all page nodes into a list of page entries
  collectPages =
    pages:
    builtins.concatMap (
      page:
      [ (builtins.removeAttrs page [ "pages" ]) ]
      ++ lib.optionals (page ? pages) (collectPages page.pages)
    ) (builtins.attrValues pages);

  # Normalised page specs
  elaboratedPageSpecs = elaboratePages [ ] pageSpecs;
  pageList = collectPages elaboratedPageSpecs;
  pagesToRender = builtins.filter (page: page ? outFile) pageList;
  pagesWithFunctions = builtins.filter (page: page.file or null != null) pageList;
in

runCommand "nixvim-lib-docs"
  {
    nativeBuildInputs = [
      nixdoc
    ];

    locations = writers.writeJSON "locations.json" (
      import ./function-locations.nix {
        inherit lib;
        rootPath = nixvim;
        functionSet = lib.extend nixvim.lib.overlay;
        pathsToScan = builtins.catAttrs "loc" pagesWithFunctions;
        revision = nixvim.rev or "main";
      }
    );

    passthru.menu = import ./menu.nix {
      inherit lib;
      pageSpecs = elaboratedPageSpecs;
    };
  }
  ''
    function docgen {
      md_file="$1"
      in_file="$2"
      name="$3"
      out_file="$out/$4"
      title="$5"

      if [[ -z "$in_file" ]]; then
        if [[ -z "$md_file" ]]; then
          >&2 echo "No markdown or nix file for $name"
          exit 1
        fi
      elif [[ -f "$in_file/default.nix" ]]; then
        in_file+="/default.nix"
      elif [[ ! -f "$in_file" ]]; then
        >&2 echo "File not found: $in_file"
        exit 1
      fi

      if [[ -n "$in_file" ]]; then
        nixdoc \
          --file "$in_file" \
          --locs "$locations" \
          --category "$name" \
          --description "REMOVED BY TAIL" \
          --prefix "" \
          --anchor-prefix "" \
        | tail --lines +2 \
        > functions.md
      fi

      default_heading="# $name"
      if [[ -n "$title" ]]; then
        default_heading+=": $title"
      fi

      print_heading=true
      if [[ -f "$md_file" ]] && [[ "$(head --lines 1 "$md_file")" == '# '* ]]; then
        >&2 echo "NOTE: markdown file for $name starts with a <h1> heading. Skipping default heading \"$default_heading\"."
        >&2 echo "      Found \"$(head --lines 1 "$md_file")\" in: $md_file"
        print_heading=false
      fi

      mkdir -p $(dirname "$out_file")
      (
        if [[ "$print_heading" = true ]]; then
          echo "$default_heading"
          echo
        fi
        if [[ -f "$md_file" ]]; then
          cat "$md_file"
          echo
        fi
        if [[ -f functions.md ]]; then
          cat functions.md
        fi
      ) > "$out_file"
    }

    mkdir -p "$out"

    ${lib.concatMapStringsSep "\n" (
      {
        name,
        file,
        markdown,
        outFile,
        title ? "",
        ...
      }:
      lib.escapeShellArgs [
        "docgen"
        "${lib.optionalString (markdown != null) markdown}" # md_file
        "${lib.optionalString (file != null) file}" # in_file
        name # name
        outFile # out_file
        title # title
      ]
    ) pagesToRender}
  ''
