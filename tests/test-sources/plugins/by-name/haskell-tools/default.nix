{
  empty = {
    plugins.haskell-tools.enable = true;
  };

  example = {
    plugins = {
      haskell-tools = {
        enable = true;
        settings = {
          hls.default_settings.haskell = {
            formattingProvider = "ormolu";
            plugin = {
              hlint = {
                codeActionsOn = false;
                diagnosticsOn = false;
              };
              importLens = {
                globalOn = false;
                codeActionsOn = false;
                codeLensOn = false;
              };
            };
          };
        };
      };
    };
  };

  defaults = {
    plugins.haskell-tools = {
      enable = true;
      settings = {
        tools = {
          codeLens = {
            autoRefresh = true;
          };
          hoogle = {
            mode = "auto";
          };
          hover = {
            enable = true;
            border = [
              [
                "╭"
                "FloatBorder"
              ]
              [
                "─"
                "FloatBorder"
              ]
              [
                "╮"
                "FloatBorder"
              ]
              [
                "│"
                "FloatBorder"
              ]
              [
                "╯"
                "FloatBorder"
              ]
              [
                "─"
                "FloatBorder"
              ]
              [
                "╰"
                "FloatBorder"
              ]
              [
                "│"
                "FloatBorder"
              ]
            ];
            stylize_markdown = false;
            auto_focus = false;
          };
          definition = {
            hoogle_signature_fallback = false;
          };
          repl = {
            handler = "builtin";
            prefer.__raw = ''
              function()
                return vim.fn.executable("stack") == 1 and "stack" or "cabal"
              end
            '';
            builtin = {
              create_repl_window.__raw = ''
                function(view)
                  return view.create_repl_split { size = vim.o.lines / 3 }
                end
              '';
            };
            auto_focus.__raw = "nil";
          };
          tags = {
            enable.__raw = ''
              function()
                return vim.fn.executable('fast-tags') == 1
              end
            '';
            package_events = [ "BufWritePost" ];
          };
          log = {
            logfile.__raw = "vim.fs.joinpath(vim.fn.stdpath('log'), 'haskell-tools.log')";
            level.__raw = "vim.log.levels.WARN";
          };
          open_url.__raw = ''
            function(url)
              require("haskell-tools.os").open_browser(url)
            end
          '';
        };

        hls = {
          auto_attach.__raw = ''
            function()
              local Types = require("haskell-tools.types.internal")
              local cmd = Types.evaluate(HTConfig.hls.cmd)
              local hls_bin = cmd[1]
              return vim.fn.executable(hls_bin) == 1
            end
          '';
          debug = false;
          on_attach.__raw = "function(_, _, _) end";
          cmd.__raw = ''
            function()
              local hls_bin = "haskell-language-server"
              local hls_wrapper_bin = hls_bin .. "-wrapper"
              local bin = vim.fn.executable(hls_wrapper_bin) == 1 and hls_wrapper_bin or hls_bin
              local cmd = { bin, "--lsp", "--logfile", HTConfig.hls.logfile }
              if HTConfig.hls.debug then
                table.insert(cmd, "--debug")
              end
              return cmd
            end
          '';
          capabilities.__raw = "vim.lsp.protocol.make_client_capabilities()";
          settings.__raw = ''
            function(project_root)
              local ht = require("haskell-tools")
              return ht.lsp.load_hls_settings(project_root)
            end
          '';
          default_settings = {
            haskell = {
              formattingProvider = "fourmolu";
              maxCompletions = 40;
              checkProject = true;
              checkParents = "CheckOnSave";
              plugin = {
                alternateNumberFormat = {
                  globalOn = true;
                };
                callHierarchy = {
                  globalOn = true;
                };
                changeTypeSignature = {
                  globalOn = true;
                };
                class = {
                  codeActionsOn = true;
                  codeLensOn = true;
                };
                eval = {
                  globalOn = true;
                  config = {
                    diff = true;
                    exception = true;
                  };
                };
                explicitFixity = {
                  globalOn = true;
                };
                gadt = {
                  globalOn = true;
                };
                "ghcide-code-actions-bindings" = {
                  globalOn = true;
                };
                "ghcide-code-actions-fill-holes" = {
                  globalOn = true;
                };
                "ghcide-code-actions-imports-exports" = {
                  globalOn = true;
                };
                "ghcide-code-actions-type-signatures" = {
                  globalOn = true;
                };
                "ghcide-completions" = {
                  globalOn = true;
                  config = {
                    autoExtendOn = true;
                    snippetsOn = true;
                  };
                };
                "ghcide-hover-and-symbols" = {
                  hoverOn = true;
                  symbolsOn = true;
                };
                "ghcide-type-lenses" = {
                  globalOn = true;
                  config = {
                    mode = "always";
                  };
                };
                haddockComments = {
                  globalOn = true;
                };
                hlint = {
                  codeActionsOn = true;
                  diagnosticsOn = true;
                };
                importLens = {
                  globalOn = true;
                  codeActionsOn = true;
                  codeLensOn = true;
                };
                moduleName = {
                  globalOn = true;
                };
                pragmas = {
                  codeActionsOn = true;
                  completionOn = true;
                };
                qualifyImportedNames = {
                  globalOn = true;
                };
                refineImports = {
                  codeActionsOn = true;
                  codeLensOn = true;
                };
                rename = {
                  globalOn = true;
                  config = {
                    crossModule = true;
                  };
                };
                retrie = {
                  globalOn = true;
                };
                splice = {
                  globalOn = true;
                };
                tactics = {
                  codeActionsOn = true;
                  codeLensOn = true;
                  config = {
                    auto_gas = 4;
                    hole_severity.__raw = "nil";
                    max_use_ctor_actions = 5;
                    proofstate_styling = true;
                    timeout_duration = 2;
                  };
                  hoverOn = true;
                };
              };
            };
          };
          logfile.__raw = ''vim.fn.tempname() .. "-haskell-language-server.log"'';
        };
        dap = {
          cmd = [ "haskell-debug-adapter" ];
          logFile.__raw = ''vim.fn.stdpath("data") .. "/haskell-dap.log"'';
          logLevel = "Warning";
          auto_discover = true;
        };
        debug_info = {
          was_g_haskell_tools_sourced.__raw = "vim.g.haskell_tools ~= nil";
        };
      };
    };
  };
}
