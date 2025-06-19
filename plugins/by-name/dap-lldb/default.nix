{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "dap-lldb";
  packPathName = "nvim-dap-lldb";
  package = "nvim-dap-lldb";
  description = "An extension for nvim-dap to provide C, C++, and Rust debugging support.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    codelldb_path =
      lib.nixvim.defaultNullOpts.mkNullableWithRaw (with lib.types; either str path) "codelldb"
        ''
          Path to codelldb executable.
        '';

    configurations =
      let
        read_args.__raw = ''
          function()
             local args = vim.fn.input("Enter args: ")
             return vim.split(args, " ", { trimempty = true })
          end
        '';

        cfg-template = {
          name = "Debug";
          type = "lldb";
          request = "launch";
          cwd = "$${workspaceFolder}";
          program.__raw = ''
            function()
               local cwd = string.format("%s%s", vim.fn.getcwd(), sep)
               return vim.fn.input("Path to executable: ", cwd, "file")
            end
          '';
          stopOnEntry = false;
        };

        c-config = [
          cfg-template
          (
            cfg-template
            // {
              name = "Debug (+args)";
              args = read_args;
            }
          )
          (
            cfg-template
            // {
              name = "Attach debugger";
              request = "attach";
            }
          )
        ];

        rust-config =
          let
            select_target.__raw = ''
              function(selection)
                 local targets = list_targets(selection)

                 if targets == nil then
                    return nil
                 end

                 if #targets == 0 then
                    return read_target()
                 end

                 if #targets == 1 then
                    return targets[1]
                 end

                 local options = { "Select a target:" }

                 for index, target in ipairs(targets) do
                    local parts = vim.split(target, sep, { trimempty = true })
                    local option = string.format("%d. %s", index, parts[#parts])
                    table.insert(options, option)
                 end

                 local choice = vim.fn.inputlist(options)

                 return targets[choice]
              end
            '';
          in
          [
            (
              cfg-template
              // {
                program = select_target;
              }
            )
            (
              cfg-template
              // {
                name = "Debug (+args)";
                program = select_target;
                args = read_args;
              }
            )
            (
              cfg-template
              // {
                name = "Debug tests";
                program.__raw = ''
                  function()
                    return select_target("tests")
                  end
                '';
                args = [ "--test-threads=1" ];
              }
            )
            (
              cfg-template
              // {
                name = "Debug tests (+args)";
                program.__raw = ''
                  function()
                    return select_target("tests")
                  end
                '';
                args.__raw = ''
                  function()
                      return vim.list_extend(read_args(), { "--test-threads=1" })
                  end
                '';
              }
            )
            (
              cfg-template
              // {
                name = "Debug tests (cursor)";
                program.__raw = ''
                  function()
                    return select_target("tests")
                  end
                '';
                args.__raw = ''
                  function()
                    local test = select_test()
                    local args = test and { "--exact", test } or {}
                    return vim.list_extend(args, { "--test-threads=1" })
                  end
                '';
              }
            )
            (
              cfg-template
              // {
                name = "Attach debugger";
                request = "attach";
              }
            )
          ];
      in
      lib.nixvim.defaultNullOpts.mkAttrsOf lib.types.anything
        {
          c = c-config;
          cpp = c-config;
          rust = rust-config;
        }
        ''
          Per programming language configuration.
        '';
  };
}
