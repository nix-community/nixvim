{
  empty = {
    plugins.ts-comments.enable = true;
  };

  default = {
    plugins.ts-comments = {
      enable = true;
      settings = {
        lang = {
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
            __default = "// %s";
            "/* %s */" = null;
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
            __unkeyed-1 = "// %s";
            __unkeyed-2 = "/* %s */";
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
        };
      };
    };
  };
}
