{ lib }:
{
  empty = {
    plugins.venv-selector.enable = true;
  };

  example = {
    plugins.venv-selector = {
      enable = true;

      settings = {
        name = [
          "venv"
          ".venv"
        ];
        dap_enabled = true;
        pyenv_path = lib.nixvim.mkRaw "vim.fn.expand('$HOME/.pyenv/versions')";
      };
    };
  };

  defaults = {
    plugins.venv-selector = {
      enable = true;

      settings = {
        cache.file = "~/.cache/venv-selector/venvs2.json";
        hooks = [
          (lib.nixvim.mkRaw "require('venv-selector.hooks').dynamic_python_lsp_hook")
        ];
        options = {
          on_venv_activate_callback.__raw = "nil";
          enable_default_searches = true;
          enable_cached_venvs = true;
          cached_venv_automatic_activation = true;
          activate_venv_in_terminal = true;
          set_environment_variables = true;
          notify_user_on_venv_activation = false;
          search_timeout = 5;
          debug = false;
          require_lsp_activation = true;
          on_telescope_result_callback.__raw = "nil";
          picker_filter_type = "substring";
          selected_venv_marker_color = "#00FF00";
          selected_venv_marker_icon = "✔";
          picker_icons.__empty = { };
          picker_columns = [
            "marker"
            "search_icon"
            "search_name"
            "search_result"
          ];
          picker = "auto";
          statusline_func = {
            nvchad.__raw = "nil";
            lualine.__raw = "nil";
          };
          picker_options = {
            snacks = {
              layout.preset = "select";
            };
          };
        };
      };
    };
  };
}
