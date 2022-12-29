# This is for plugins not in nixpkgs
# e.g. intellitab.nvim
# Ideally, in the future, this would all be specified as a flake input!
{ pkgs, ... }:
{
  intellitab-nvim = pkgs.vimUtils.buildVimPlugin rec {
    pname = "intellitab-nvim";
    version = "a6c1a505865f6131866d609c52440306e9914b16";
    src = pkgs.fetchFromGitHub {
      owner = "pta2002";
      repo = "intellitab.nvim";
      rev = version;
      sha256 = "19my464jsji7cb81h0agflzb0vmmb3f5kapv0wwhpdddcfzvp4fg";
    };
  };
  mark-radar = pkgs.vimUtils.buildVimPlugin rec {
    pname = "mark-radar";
    version = "d7fb84a670795a5b36b18a5b59afd1d3865cbec7";
    src = pkgs.fetchFromGitHub {
      owner = "winston0410";
      repo = "mark-radar.nvim";
      rev = version;
      sha256 = "1y3l2c7h8czhw0b5m25iyjdyy0p4nqk4a3bxv583m72hn4ac8rz9";
    };
  };
  coq-nvim = pkgs.vimUtils.buildVimPlugin rec {
    pname = "coq-nvim";
    version = "2699492a1b8716c59ade7130dc354e53944b6a7f";
    src = pkgs.fetchFromGitHub {
      owner = "ms-jpq";
      repo = "coq_nvim";
      rev = version;
      sha256 = "sha256-tjniIWe1V4vGuao5no+3YB9WtiNaMehEjffJyNpFgd8=";
    };

    passthru.python3Dependencies = ps: [
      ps.pynvim
      ps.pyyaml
      (ps.buildPythonPackage rec {
        pname = "pynvim_pp";
        version = "01dc0f58d4e71a98c388e1f37bda3d1357089fa2";

        src = pkgs.fetchFromGitHub {
          owner = "ms-jpq";
          repo = "pynvim_pp";
          rev = version;
          sha256 = "sha256-/m4Paw6AvDzTMWWCWpPnrdI4gsjIDSJPvGCMV7ufbEA=";
        };

        propagatedBuildInputs = [ pkgs.python3Packages.pynvim ];
      })
      (ps.buildPythonPackage rec {
        pname = "std2";
        version = "48bb39b69ed631ef64eed6123443484133fd20fc";

        doCheck = true;

        src = pkgs.fetchFromGitHub {
          owner = "ms-jpq";
          repo = "std2";
          rev = version;
          sha256 = "sha256-nMwNAq15zyf9ORhFGo0sawQukOygYoVWtT7jH68MIkI=";
        };
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

  coq-artifacts = pkgs.vimUtils.buildVimPlugin rec {
    pname = "coq.artifacts";
    version = "495429564e481cafeb044456da32c10cb631f948";

    src = pkgs.fetchFromGitHub {
      owner = "ms-jpq";
      repo = "coq.artifacts";
      rev = version;
      sha256 = "sha256-AtkG2XRVZgvJzH2iLr7UT/U1+LXxenvNckdapnJV+8A=";
    };
  };

  magma-nvim = pkgs.vimUtils.buildVimPlugin rec {
    pname = "magma-nvim";
    version = "94370733757d550594fe4a1d65643949d7485989";

    src = pkgs.fetchFromGitHub {
      owner = "WhiteBlackGoose";
      repo = "magma-nvim-goose";
      rev = version;
      sha256 = "sha256-IaslJK1F2BxTvZzKGH9OKOl2RICi4d4rSgjliAIAqK4=";
    };



    passthru.python3Dependencies = ps: with ps;  [
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
