{
  python3,
  lib,
  nixos-render-docs,
}:
python3.pkgs.buildPythonApplication {
  pname = "nixvim-render-docs";
  version = "0.0";
  format = "pyproject";

  src = lib.cleanSourceWith {
    filter = name: type:
      lib.cleanSourceFilter name type
      && ! (type
        == "directory"
        && builtins.elem (baseNameOf name) [
          ".pytest_cache"
          ".mypy_cache"
          "__pycache__"
        ]);
    src = ./src;
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = [
    nixos-render-docs
  ];
}
