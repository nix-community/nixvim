{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "ts-comments";
  packPathName = "ts-comments.nvim";
  package = "ts-comments-nvim";
  description = "A Neovim plugin that provides comment strings for various languages using Treesitter.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    lang =
      lib.nixvim.defaultNullOpts.mkAttrsOf lib.types.anything
        {
          astro = "";
          axaml = "";
          blueprint = "// %s";
          c = "// %s";
          c_sharp = "// %s";
          clojure = [
            ";; %s"
            "; %s"
          ];
          cpp = "// %s";
          cs_project = "";
          cue = "// %s";
          fsharp = "// %s";
          fsharp_project = "";
          gleam = "// %s";
          glimmer = "{{! %s }}";
          graphql = "# %s";
          handlebars = "{{! %s }}";
          hcl = "# %s";
          html = "";
          hyprlang = "# %s";
          ini = "; %s";
          ipynb = "# %s";
          javascript = {
            __unkeyed-1 = "// %s";
            __unkeyed-2 = "/* %s */";
            call_expression = "// %s";
            jsx_attribute = "// %s";
            jsx_element = "{/* %s */}";
            jsx_fragment = "{/* %s */}";
            spread_element = "// %s";
            statement_block = "// %s";
          };
          kdl = "// %s";
          php = "// %s";
          rego = "# %s";
          rescript = "// %s";
          rust = [
            "// %s"
            "/* %s */"
          ];
          sql = "-- %s";
          styled = "/* %s */";
          svelte = "";
          templ = {
            __default = "// %s";
            component_block = "";
          };
          terraform = "# %s";
          tsx = {
            __default = "// %s";
            "/* %s */" = null;
            call_expression = "// %s";
            jsx_attribute = "// %s";
            jsx_element = "{/* %s */}";
            jsx_fragment = "{/* %s */}";
            spread_element = "// %s";
            statement_block = "// %s";
          };
          twig = "{# %s #}";
          typescript = [
            "// %s"
            "/* %s */"
          ];
          vue = "";
          xaml = "";
        }
        ''
          Configure comment string for each language.

          `ts-comments.nvim` uses the default Neovim `commentstring` as a fallback, so there's no need to configure every language.
        '';
  };
}
