{ pkgs, ... }:
{
  empty = {
    plugins.telescope = {
      enable = true;
      extensions.live-grep-args.enable = true;
    };
    plugins.web-devicons.enable = true;
  };

  default = {
    plugins.telescope = {
      enable = true;

      extensions.live-grep-args = {
        enable = true;

        settings = {
          auto_quoting = true;
          mappings.__empty = { };
        };
      };
    };
    plugins.web-devicons.enable = true;
  };

  example = {
    plugins.telescope = {
      enable = true;

      extensions.live-grep-args = {
        enable = true;

        settings = {
          auto_quoting = true;
          mappings = {
            i = {
              "<C-k>".__raw = ''require("telescope-live-grep-args.actions").quote_prompt()'';
              "<C-i>".__raw =
                ''require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " })'';
              "<C-space>".__raw = ''require("telescope-live-grep-args.actions").to_fuzzy_refine'';
            };
          };
          theme = "dropdown";
        };
      };
    };
    plugins.web-devicons.enable = true;
  };

  custom-packages = {
    plugins = {
      telescope = {
        enable = true;

        extensions.live-grep-args.enable = true;
      };
      web-devicons.enable = true;
    };
    dependencies.ripgrep.package = pkgs.gnugrep;
  };

  no-packages = {
    plugins = {
      telescope = {
        enable = true;

        extensions.live-grep-args.enable = true;
      };
      web-devicons.enable = false;
    };
    dependencies.ripgrep.enable = false;
  };
}
