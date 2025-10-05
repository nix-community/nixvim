{
  empty = {
    plugins = {
      treesitter.enable = true;
      ts-context-commentstring.enable = true;
    };
  };

  example = {
    plugins = {
      treesitter.enable = true;
      ts-context-commentstring = {
        enable = true;
        settings = {
          enable_autocmd = false;
          languages = {
            haskell = "-- %s";
            nix = {
              __default = "# %s";
              __multiline = "/* %s */";
            };
          };
        };
      };
    };
  };

  defaults = {
    plugins = {
      treesitter.enable = true;
      ts-context-commentstring = {
        enable = true;
        settings = {
          enable_autocmd = true;

          custom_calculation.__raw = "nil";

          commentary_integration = {
            Commentary = "gc";
            CommentaryLine = "gcc";
            ChangeCommentary = "cgc";
            CommentaryUndo = "gcu";
          };

          languages = {
            astro = "<!-- %s -->";
            c = "/* %s */";
            cpp = {
              __default = "// %s";
              __multiline = "/* %s */";
            };
            css = "/* %s */";
            cue = "// %s";
            gleam = "// %s";
            glimmer = "{{! %s }}";
            go = {
              __default = "// %s";
              __multiline = "/* %s */";
            };
            graphql = "# %s";
            haskell = "-- %s";
            handlebars = "{{! %s }}";
            hcl = {
              __default = "# %s";
              __multiline = "/* %s */";
            };
            html = "<!-- %s -->";
            htmldjango = {
              __default = "{# %s #}";
              __multiline = "{% comment %} %s {% endcomment %}";
            };
            ini = "; %s";
            lua = {
              __default = "-- %s";
              __multiline = "--[[ %s ]]";
            };
            nix = {
              __default = "# %s";
              __multiline = "/* %s */";
            };
            php = {
              __default = "// %s";
              __multiline = "/* %s */";
            };
            python = {
              __default = "# %s";
              __multiline = ''""" %s """'';
            };
            rego = "# %s";
            rescript = {
              __default = "// %s";
              __multiline = "/* %s */";
            };
            scss = {
              __default = "// %s";
              __multiline = "/* %s */";
            };
            sh = "# %s";
            bash = "# %s";
            solidity = {
              __default = "// %s";
              __multiline = "/* %s */";
            };
            sql = "-- %s";
            svelte = "<!-- %s -->";
            terraform = {
              __default = "# %s";
              __multiline = "/* %s */";
            };
            twig = "{# %s #}";
            typescript = {
              __default = "// %s";
              __multiline = "/* %s */";
            };
            typst = {
              __default = "// %s";
              __multiline = "/* %s */";
            };
            vim = ''" %s'';
            vue = "<!-- %s -->";
            zsh = "# %s";
            kotlin = {
              __default = "// %s";
              __multiline = "/* %s */";
            };
            roc = "# %s";

            tsx = {
              __default = "// %s";
              __multiline = "/* %s */";
              jsx_element = "{/* %s */}";
              jsx_fragment = "{/* %s */}";
              jsx_attribute = {
                __default = "// %s";
                __multiline = "/* %s */";
              };
              comment = {
                __default = "// %s";
                __multiline = "/* %s */";
              };
              call_expression = {
                __default = "// %s";
                __multiline = "/* %s */";
              };
              statement_block = {
                __default = "// %s";
                __multiline = "/* %s */";
              };
              spread_element = {
                __default = "// %s";
                __multiline = "/* %s */";
              };
            };

            templ = {
              __default = "// %s";
              component_block = "<!-- %s -->";
            };
          };

          not_nested_languages = {
            htmldjango = true;
          };

          config.__raw = "{}";
        };
      };
    };
  };
}
