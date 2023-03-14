# This is for plugins not in nixpkgs
# e.g. intellitab.nvim
#
# This is generated through nvfetcher, the plugins are defined in nvfetcher.toml.
# You can update the plugins by running `nvfetcher` in this directory
{pkgs, ...}: let
  sources = pkgs.callPackage ./_sources/generated.nix {};
in {
  intellitab-nvim = pkgs.vimUtils.buildVimPlugin {
    inherit (sources.intellitab-nvim) pname version src;
  };
  mark-radar = pkgs.vimUtils.buildVimPlugin {
    inherit (sources.mark-radar) pname version src;
  };
  coq-nvim = pkgs.vimUtils.buildVimPlugin {
    inherit (sources.coq-nvim) pname version src;

    passthru.python3Dependencies = ps: [
      ps.pynvim
      ps.pyyaml
      (ps.buildPythonPackage {
        inherit (sources.pynvim_pp) pname version src;

        propagatedBuildInputs = [pkgs.python3Packages.pynvim];
      })
      (ps.buildPythonPackage {
        inherit (sources.std2) pname version src;
        doCheck = true;
      })
    ];

    # We need some patches so it stops complaining about not being in a venv
    postPatch = ''
      substituteInPlace coq/consts.py \
        --replace "VARS = TOP_LEVEL / \".vars\"" "VARS = Path.home() / \".cache/home/vars\"";
      substituteInPlace coq/__main__.py \
        --replace "_IN_VENV = _RT_PY == _EXEC_PATH" "_IN_VENV = True"
    '';
  };

  coq-artifacts = pkgs.vimUtils.buildVimPlugin {
    inherit (sources.coq-artifacts) pname version src;
  };

  magma-nvim = pkgs.vimUtils.buildVimPlugin {
    inherit (sources.magma-nvim) pname version src;

    passthru.python3Dependencies = ps:
      with ps; [
        pynvim
        jupyter-client
        ueberzug
        pillow
        cairosvg
        plotly
        ipykernel
        pyperclip
        (ps.buildPythonPackage rec {
          pname = "pnglatex";
          version = "1.1";
          src = fetchPypi {
            inherit pname version;
            hash = "sha256-CZUGDUkmttO0BzFYbGFSNMPkWzFC/BW4NmAeOwz4Y9M=";
          };
          doCheck = false;
          meta = with lib; {
            homepage = "https://github.com/MaT1g3R/pnglatex";
            description = "a small program that converts LaTeX snippets to png";
          };
        })
      ];
  };
}
