{ config, lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "gdscript-extended-lsp";
  package = "gdscript-extended-lsp-nvim";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    picker = "snacks";
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.gdscript-extended-lsp" (
      lib.mapAttrsToList
        (picker: pluginName: {
          when =
            (cfg.settings ? picker && cfg.settings.picker == picker) && !config.plugins.${pluginName}.enable;
          message = ''
            You have set `plugins.gdscript-extended-lsp.settings.picker = "${picker}"` but `plugins.${pluginName}` is not enabled in your config.
          '';
        })
        {
          telescope = "telescope";
          snacks = "snacks";
        }
    );
  };
}
