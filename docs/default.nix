{ pkgs ? import <nixpkgs> { }
, lib ? import <nixpkgs/lib>
, nixvimModules ? [ ]
, ...
}:
let
  nmdSrc = pkgs.fetchFromGitLab {
    name = "nmd";
    owner = "rycee";
    repo = "nmd";
    rev = "527245ff605bde88c2dd2ddae21c6479bb7cf8aa";
    sha256 = "1zi0f9y3wq4bpslx1py3sfgrgd9av41ahpandvs6rvkpisfsqqlp";
  };
  nmd = import nmdSrc { inherit pkgs lib; };
  scrubbedPkgsModule = {
    imports = [{
      _module.args = {
        pkgs = lib.mkForce (nmd.scrubDerivations "pkgs" pkgs);
        pkgs_i686 = lib.mkForce { };
      };
    }];
  };
  buildModulesDocs = args:
    nmd.buildModulesDocs ({
      moduleRootPaths = [ ./.. ];
      mkModuleUrl = path:
        "https://github.com/pta2002/nixvim/blob/main/${path}#blob-path";
      channelName = "nixvim";
    } // args);
  nixvimDocs = buildModulesDocs {
    modules = [
      scrubbedPkgsModule
    ] ++ nixvimModules;
    docBook.id = "nixvim-options";
  };

  docs = nmd.buildDocBookDocs {
    pathName = "";
    modulesDocs = [ nixvimDocs ];
    documentsDirectory = ./.;
    documentType = "book";
    chunkToc = ''
      <toc>
        <d:tocentry xmlns:d="http://docbook.org/ns/docbook" linkend="book-nixvim-manual"><?dbhtml filename="index.html"?>
          <d:tocentry linkend="ch-options"><?dbhtml filename="options.html"?></d:tocentry>
          <d:tocentry linkend="ch-release-notes"><?dbhtml filename="release-notes.html"?></d:tocentry>
        </d:tocentry>
        </toc>
    '';
  };
in
docs.html
