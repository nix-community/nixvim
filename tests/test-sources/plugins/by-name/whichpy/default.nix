{
  empty = {
    plugins.whichpy.enable = true;
  };

  defaults = {
    plugins.whichpy = {
      enable = true;

      settings = {
        cache_dir.__raw = "vim.fn.stdpath('cache') .. '/whichpy.nvim'";
        update_path_env = false;
        after_handle_select.__raw = "nil";
        picker = {
          name = "builtin";
        };
        locator = {
          workspace = {
            display_name = "Workspace";
            search_pattern = ".*env.*";
            depth = 2;
            ignore_dirs = [
              ".git"
              ".mypy_cache"
              ".pytest_cache"
              ".ruff_cache"
              "__pycache__"
              "__pypackages__"
            ];
          };
          global = {
            display_name = "Global";
          };
          global_virtual_environment = {
            display_name = "Global Virtual Environment";
            dirs = [
              "~/envs"
              "~/.direnv"
              "~/.venvs"
              "~/.virtualenvs"
              "~/.local/share/virtualenvs"
              [
                "~/Envs"
                "Windows_NT"
              ]
              { __raw = "vim.env.WORKON_HOME"; }
            ];
          };
          pyenv = {
            display_name = "Pyenv";
            venv_only = true;
          };
          poetry = {
            display_name = "Poetry";
          };
          pdm = {
            display_name = "PDM";
          };
          conda = {
            display_name = "Conda";
          };
        };
        lsp = {
          pylsp.__raw = "require('whichpy.lsp.handlers.pylsp').new()";
          pyright.__raw = "require('whichpy.lsp.handlers.pyright').new()";
          basedpyright.__raw = "require('whichpy.lsp.handlers.pyright').new()";
        };
      };
    };
  };

  example = {
    plugins.whichpy = {
      enable = true;

      settings = {
        update_path_env = true;
        locator = {
          workspace.depth = 3;
          uv.enable = true;
        };
      };
    };
  };
}
