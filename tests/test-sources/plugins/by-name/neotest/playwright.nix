{
  example = {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.playwright = {
          enable = true;

          settings.options = {
            persist_project_selection = false;
            enable_dynamic_test_discovery = false;
            preset = "none";
            get_playwright_binary.__raw = ''
              function()
                return vim.uv.cwd() + "/node_modules/.bin/playwright"
              end
            '';
            get_playwright_config.__raw = ''
              function()
                return vim.uv.cwd() + "/playwright.config.ts"
              end
            '';
            get_cwd.__raw = ''
              function()
                return vim.uv.cwd()
              end
            '';
            env = { };
            extra_args = [ ];
            filter_dir.__raw = ''
              function(name, rel_path, root)
                return name ~= "node_modules"
              end
            '';
            is_test_file.__raw = ''
              function(file_path)
                return string.match(file_path, "my-project's-vitest-tests-folder")
              end
            '';
          };
        };
      };
    };
  };
}
