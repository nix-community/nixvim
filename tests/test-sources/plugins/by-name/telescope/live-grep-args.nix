{ pkgs, ... }:
{
  empty = {
    plugins.telescope = {
      enable = true;
      extensions.live-grep-args.enable = true;
    };
  };

  default = {
    plugins.telescope = {
      enable = true;

      extensions.live-grep-args = {
        enable = true;

        settings = {
          auto_quoting = true;
          mappings = { };
        };
      };
    };
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
              "<C-i>".__raw = ''require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " })'';
              "<C-space>".__raw = ''require("telescope-live-grep-args.actions").to_fuzzy_refine'';
            };
          };
          theme = "dropdown";
        };
      };
    };
  };

  custom-packages = {
    plugins.telescope = {
      enable = true;

      extensions.live-grep-args = {
        enable = true;
        grepPackage = pkgs.gnugrep;
      };
    };
  };

  no-packages = {
    plugins.telescope = {
      enable = true;

      extensions.live-grep-args = {
        enable = true;
        grepPackage = null;
      };
    };
  };
}
