{ lib }:
{
  empty = {
    plugins.luau-lsp.enable = true;
  };

  defaults = {
    plugins.luau-lsp = {
      enable = true;

      settings = {
        fflags = {
          enable_by_default = false;
          enable_new_solver = false;
          override = lib.nixvim.emptyTable;
          sync = true;
        };

        platform = {
          type = "roblox";
        };

        plugin = {
          enabled = false;
          port = 3667;
        };

        server = {
          path = "luau-lsp";
        };

        sourcemap = {
          autogenerate = true;
          enabled = true;
          generator_cmd = lib.nixvim.mkRaw "nil";
          include_non_scripts = true;
          rojo_path = "rojo";
          rojo_project_file = "default.project.json";
          sourcemap_file = "sourcemap.json";
        };

        types = {
          definition_files = lib.nixvim.emptyTable;
          documentation_files = lib.nixvim.emptyTable;
          roblox_security_level = "PluginSecurity";
        };
      };
    };
  };

  example = {
    plugins.luau-lsp = {
      enable = true;

      settings = {
        platform.type = "roblox";
        types.roblox_security_level = "PluginSecurity";

        sourcemap = {
          enabled = true;
          autogenerate = true;
          rojo_project_file = "default.project.json";
          sourcemap_file = "sourcemap.json";
        };
      };
    };
  };
}
