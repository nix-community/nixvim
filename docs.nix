{
  pkgs,
  lib,
  modules,
  ...
}: let
  options = lib.evalModules {
    inherit modules;
    specialArgs = {inherit pkgs lib;};
  };
  docs = pkgs.nixosOptionsDoc {
    # If we don't do this, we end up with _module.args on the generated options, which we do not want
    options = lib.filterAttrs (k: _: k != "_module") options.options;
    warningsAreErrors = false;
  };
  asciidoc = docs.optionsAsciiDoc;
in
  pkgs.stdenv.mkDerivation {
    name = "nixvim-docs";

    src = asciidoc;
    buildInputs = [
      pkgs.asciidoctor
    ];

    phases = ["buildPhase"];

    buildPhase = ''
      mkdir -p $out/share/doc
      cat <<EOF > header.adoc
      = NixVim options
      This lists all the options available for NixVim.
      :toc:

      EOF
      cat header.adoc $src > tmp.adoc
      asciidoctor tmp.adoc -o $out/share/doc/index.html
    '';
  }
