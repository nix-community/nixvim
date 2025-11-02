{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "luau-lsp";
  package = "luau-lsp-nvim";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    platform.type = "roblox";
    types.roblox_security_level = "PluginSecurity";

    sourcemap = {
      enabled = true;
      autogenerate = true;
      rojo_project_file = "default.project.json";
      sourcemap_file = "sourcemap.json";
    };
  };
}
