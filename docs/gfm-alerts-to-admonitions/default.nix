{
  buildPythonPackage,
  pytestCheckHook,
  markdown-it-py,
  lib,
  setuptools,
  pytest-regressions,
}:
buildPythonPackage {
  pname = "gfm-alerts-to-admonitions";
  version = "0.0";
  format = "pyproject";

  src = ./.;

  build-system = [ setuptools ];
  dependencies = [ markdown-it-py ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-regressions
  ];
  pythonImportsCheck = [ "gfm_alerts_to_admonitions" ];

  meta = {
    description = "Transform GFM alerts to nixos-render-docs admonitions";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.traxys ];
  };
}
