{ config, lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "gdscript-extended-lsp";
  package = "gdscript-extended-lsp-nvim";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    picker = "snacks";
  };

  extraConfig = cfg: opts: {
    warnings = lib.nixvim.mkWarnings "plugins.gdscript-extended-lsp" (
      lib.mapAttrsToList
        (picker: pluginName: {
          when = cfg.settings.picker or null == picker && !config.plugins.${pluginName}.enable;
          message = ''
            You have defined `${opts.settings}.picker = "${picker}"` but `plugins.${pluginName}` is not enabled.
          '';
        })
        {
          telescope = "telescope";
          snacks = "snacks";
        }
    );
  };
}
