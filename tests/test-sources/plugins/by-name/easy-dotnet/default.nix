{
  empty = {
    plugins.easy-dotnet.enable = true;
  };

  defaults = {
    plugins = {
      telescope.enable = true;
      web-devicons.enable = true;
      easy-dotnet = {
        enable = true;

        settings = {
          get_sdk_path.__raw = ''
            function()
              local sdk_version = vim.trim(vim.fn.system("dotnet --version"))
              local sdk_list = vim.trim(vim.fn.system("dotnet --list-sdks"))
              local base = nil
              for line in sdk_list:gmatch("[^\n]+") do
                if line:find(sdk_version, 1, true) then
                  base = vim.fs.normalize(line:match("%[(.-)%]"))
                  break
                end
              end
              local sdk_path = polyfills.fs.joinpath(base, sdk_version):gsub("Program Files", '"Program Files"')
              return sdk_path
            end
          '';
          terminal.__raw = ''
            function(path, action, args)
              local commands = {
                run = function() return string.format("dotnet run --project %s %s", path, args) end,
                test = function() return string.format("dotnet test %s %s", path, args) end,
                restore = function() return string.format("dotnet restore %s %s", path, args) end,
                build = function() return string.format("dotnet build %s %s", path, args) end,
              }
              local command = commands[action]()
              if require("easy-dotnet.extensions").isWindows() == true then command = command .. "\r" end
              vim.cmd("vsplit")
              vim.cmd("term " .. command)
            end
          '';
          secrets = {
            path.__raw = ''
              function()
                local path = ""
                local home_dir = vim.fn.expand("~")
                if require("easy-dotnet.extensions").isWindows() then
                  local secret_path = home_dir .. "\\AppData\\Roaming\\Microsoft\\UserSecrets\\" .. secret_guid .. "\\secrets.json"
                  path = secret_path
                else
                  local secret_path = home_dir .. "/.microsoft/usersecrets/" .. secret_guid .. "/secrets.json"
                  path = secret_path
                end
                return path
              end
            '';
          };
          test_runner = {
            viewmode = "split";
            enable_buffer_test_execution = true;
            noBuild = true;
            noRestore = true;
            icons = {
              passed = "";
              skipped = "";
              failed = "";
              success = "";
              reload = "";
              test = "";
              sln = "󰘐";
              project = "󰘐";
              dir = "";
              package = "";
            };
            mappings = {
              run_test_from_buffer = {
                lhs = "<leader>r";
                desc = "run test from buffer";
              };
              debug_test_from_buffer = {
                lhs = "<leader>d";
                desc = "run test from buffer";
              };
              filter_failed_tests = {
                lhs = "<leader>fe";
                desc = "filter failed tests";
              };
              debug_test = {
                lhs = "<leader>d";
                desc = "debug test";
              };
              go_to_file = {
                lhs = "g";
                desc = "go to file";
              };
              run_all = {
                lhs = "<leader>R";
                desc = "run all tests";
              };
              run = {
                lhs = "<leader>r";
                desc = "run test";
              };
              peek_stacktrace = {
                lhs = "<leader>p";
                desc = "peek stacktrace of failed test";
              };
              expand = {
                lhs = "o";
                desc = "expand";
              };
              expand_node = {
                lhs = "E";
                desc = "expand node";
              };
              expand_all = {
                lhs = "-";
                desc = "expand all";
              };
              collapse_all = {
                lhs = "W";
                desc = "collapse all";
              };
              close = {
                lhs = "q";
                desc = "close testrunner";
              };
              refresh_testrunner = {
                lhs = "<C-r>";
                desc = "refresh testrunner";
              };
            };
            additional_args = [ ];
          };
          csproj_mappings = true;
          fsproj_mappings = true;
          auto_bootstrap_namespace = {
            type = "block_scoped";
            enabled = true;
          };
          picker = "telescope";
        };
      };
    };
  };

  example = {
    plugins = {
      fzf-lua.enable = true;
      easy-dotnet = {
        enable = true;

        settings = {
          test_runner = {
            enable_buffer_test_execution = true;
            viewmode = "float";
          };
          auto_bootstrap_namespace = true;
          terminal.__raw = ''
            function(path, action, args)
              local commands = {
                run = function()
                  return string.format("dotnet run --project %s %s", path, args)
                end,
                test = function()
                  return string.format("dotnet test %s %s", path, args)
                end,
                restore = function()
                  return string.format("dotnet restore %s %s", path, args)
                end,
                build = function()
                  return string.format("dotnet build %s %s", path, args)
                end,
              }

              local command = commands[action]() .. "\r"
              require("toggleterm").exec(command, nil, nil, nil, "float")
            end
          '';
          picker = "fzf";
        };
      };
    };
  };
}
