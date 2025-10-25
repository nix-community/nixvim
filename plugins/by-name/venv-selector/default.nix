{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "venv-selector";
  package = "venv-selector-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [
    "fd"
  ];

  settingsExample = {
    name = [
      "venv"
      ".venv"
    ];
    dap_enabled = true;
    pyenv_path = lib.nixvim.nestedLiteralLua "vim.fn.expand('$HOME/.pyenv/versions')";
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.venv-selector" (
      lib.map
        (pickerName: {
          when = (cfg.settings.picker or null) == pickerName && !config.plugins.${pickerName}.enable;
          message = ''
            You have to enable `plugins.${pickerName}` as `settings.picker` is set to `"${pickerName}"`.
          '';
        })
        [
          "telescope"
          "fzf-lua"
        ]
    );
  };
}
