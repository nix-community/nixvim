{
  lib,
  buildPythonPackage,
  nixos-render-docs,
  pytestCheckHook,
  setuptools,
}:
let
  inherit (lib.importTOML ./pyproject.toml) project;
in
buildPythonPackage {
  pname = project.name;
  inherit (project) version;
  format = "pyproject";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.fileFilter (file: !file.hasExt "nix") ./.;
  };

  build-system = [ setuptools ];
  dependencies = [ nixos-render-docs ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
  pythonImportsCheck = [ "multipage_render_docs" ];

  meta = {
    inherit (project) description;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.MattSturgeon ];
    mainProgram = "multipage-render-docs";
  };
}
