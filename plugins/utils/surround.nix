{
  config,
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
  helpers.neovim-plugin.mkNeovimPlugin config {
    name = "surround";
    luaName = "nvim-surround";
    originalName = "nvim-surround";
    defaultPackage = pkgs.vimPlugins.nvim-surround;

    maintainers = [helpers.maintainers.AndresBermeoMarinelli];

    settingsOptions = {
      keymaps =
        helpers.defaultNullOpts.mkAttrsOf types.str
        ''
          {
            insert = "<C-g>s";
            insert_line = "<C-g>S";
            normal = "ys";
            normal_cur = "yss";
            normal_line = "yS";
            normal_cur_line = "ySS";
            visual = "S";
            visual_line = "gS";
            delete = "ds";
            change = "cs";
            change_line = "cS";
          }
        ''
        "Defines the keymaps used to perform surround actions.";

      aliases =
        helpers.defaultNullOpts.mkAttrsOf (with types; either str (listOf str))
        ''
          {
            "a" = ">";
            "b" = ")";
            "B" = "}";
            "r" = "]";
            "q" = [ "\"" "'" "`" ];
            "s" = [ "}" "]" ")" ">" "\"" "'" "`" ];
          }
        ''
        "Maps characters to other characters, or lists of characters.";

      surrounds = let
        surroundType = types.submodule {
          options = {
            add = mkOption {
              type = with helpers.nixvimTypes; either strLuaFn (listOf str);
              description = ''
                A function that returns the delimiter pair to be added to the buffer.
                For "static" delimiter pairs it can be a list of strings representing the value
                of the delimiter pair.
              '';
              apply = v:
                if isString v
                then helpers.mkRaw v
                else v;
              example = ["( " " )"];
            };
            find = mkOption {
              type = with helpers.nixvimTypes; maybeRaw str;
              description = ''
                A function that returns the "parent selection" for a surrounding pair.
                It can also be string which is interpreted as a Lua pattern that represents the
                selection.
              '';
              example.__raw = ''
                function()
                  return M.get_selection({ motion = "a(" })
                end
              '';
            };
            delete = mkOption {
              type = with helpers.nixvimTypes; maybeRaw str;
              description = ''
                A function that returns the pair of selections to remove from the buffer when
                deleting the surrounding pair.
                It can also be string which is interpreted as a Lua pattern whose match groups
                represent the left/right delimiter pair.
              '';
              example = "^(. ?)().-( ?.)()$";
            };

            change = helpers.mkNullOrOption (types.submodule {
              options = {
                target = mkOption {
                  type = with helpers.nixvimTypes; maybeRaw str;
                  description = ''
                    A function that returns the pair of selections to be replaced in the buffer
                    when changing the surrounding pair.
                    It can also be a string which is interpreted as a Lua pattern whose match
                    groups represent the left/right delimiter pair.
                  '';
                  example = "^<([^>]*)().-([^%/]*)()>$";
                };
                replacement = mkOption {
                  type = helpers.nixvimTypes.rawLua;
                  description = ''
                    A function that returns the surrounding pair to replace the target
                    selections.
                  '';
                  example.__raw = ''
                    function()
                        local result = M.get_input("Enter the function name: ")
                        if result then
                            return { { result }, { "" } }
                        end
                    end
                  '';
                };
              };
            }) "An attribute set with two keys: `target` and `replacement`.";
          };
        };
      in
        helpers.mkNullOrOption (types.attrsOf surroundType)
        ''
          Associates each key with a "surround". The attribute set contains
          the 'add', 'find', 'delete', and 'change' keys.

          Default: see upstream documentation.
        '';
    };

    settingsExample = {
      keymaps = {
        insert = "<C-g>s";
        insert_line = "<C-g>S";
        normal = "ys";
        normal_cur = "yss";
        normal_line = "yS";
        normal_cur_line = "ySS";
        visual = "S";
        visual_line = "gS";
        delete = "ds";
        change = "cs";
        change_line = "cS";
      };

      surrounds = {
        "(" = {
          add = ["( " " )"];
          find.__raw = ''
            function()
                return M.get_selection({ motion = "a(" })
            end
          '';
          delete = "^(. ?)().-( ?.)()$";
        };

        ")" = {
          add = ["(" ")"];
          find.__raw = ''
            function()
                return M.get_selection({ motion = "a)" })
            end
          '';
          delete = "^(.)().-(.)()$";
        };

        "{" = {
          add = ["{ " " }"];
          find.__raw = ''
            function()
                return M.get_selection({ motion = "a{" })
            end
          '';
          delete = "^(. ?)().-( ?.)()$";
        };

        "}" = {
          add = ["{" "}"];
          find.__raw = ''
            function()
                return M.get_selection({ motion = "a}" })
            end
          '';
          delete = "^(.)().-(.)()$";
        };

        "<" = {
          add = ["< " " >"];
          find.__raw = ''
            function()
                return M.get_selection({ motion = "a<" })
            end
          '';
          delete = "^(. ?)().-( ?.)()$";
        };

        ">" = {
          add = ["<" ">"];
          find.__raw = ''
            function()
                return M.get_selection({ motion = "a>" })
            end
          '';
          delete = "^(.)().-(.)()$";
        };

        "[" = {
          add = ["[ " " ]"];
          find.__raw = ''
            function()
                return M.get_selection({ motion = "a[" })
            end
          '';
          delete = "^(. ?)().-( ?.)()$";
        };

        "]" = {
          add = ["[" "]"];
          find.__raw = ''
            function()
                return M.get_selection({ motion = "a]" })
            end
          '';
          delete = "^(.)().-(.)()$";
        };

        "'" = {
          add = ["'" "'"];
          find.__raw = ''
            function()
                return M.get_selection({ motion = "a'" })
            end
          '';
          delete = "^(.)().-(.)()$";
        };

        "\"" = {
          add = ["\"" "\""];
          find.__raw = ''
            function()
                return M.get_selection({ motion = 'a"' })
            end
          '';
          delete = "^(.)().-(.)()$";
        };

        "`" = {
          add = ["`" "`"];
          find.__raw = ''
            function()
                return M.get_selection({ motion = "a`" })
            end
          '';
          delete = "^(.)().-(.)()$";
        };

        "i" = {
          add = ''
            function()
                local left_delimiter = M.get_input("Enter the left delimiter: ")
                local right_delimiter = left_delimiter and M.get_input("Enter the right delimiter: ")
                if right_delimiter then
                    return { { left_delimiter }, { right_delimiter } }
                end
            end
          '';
          find.__raw = "function() end";
          delete.__raw = "function() end";
        };

        "t" = {
          add = ''
            function()
                local user_input = M.get_input("Enter the HTML tag: ")
                if user_input then
                    local element = user_input:match("^<?([^%s>]*)")
                    local attributes = user_input:match("^<?[^%s>]*%s+(.-)>?$")

                    local open = attributes and element .. " " .. attributes or element
                    local close = element

                    return { { "<" .. open .. ">" }, { "</" .. close .. ">" } }
                end
            end
          '';
          find.__raw = ''
            function()
                return M.get_selection({ motion = "at" })
            end
          '';
          delete = "^(%b<>)().-(%b<>)()$";
          change = {
            target = "^<([^%s<>]*)().-([^/]*)()>$";
            replacement.__raw = ''
              function()
                  local user_input = M.get_input("Enter the HTML tag: ")
                  if user_input then
                      local element = user_input:match("^<?([^%s>]*)")
                      local attributes = user_input:match("^<?[^%s>]*%s+(.-)>?$")

                      local open = attributes and element .. " " .. attributes or element
                      local close = element

                      return { { open }, { close } }
                  end
              end
            '';
          };
        };

        "T" = {
          add = ''
            function()
                local user_input = M.get_input("Enter the HTML tag: ")
                if user_input then
                    local element = user_input:match("^<?([^%s>]*)")
                    local attributes = user_input:match("^<?[^%s>]*%s+(.-)>?$")

                    local open = attributes and element .. " " .. attributes or element
                    local close = element

                    return { { "<" .. open .. ">" }, { "</" .. close .. ">" } }
                end
            end
          '';
          find.__raw = ''
            function()
                return M.get_selection({ motion = "at" })
            end
          '';
          delete = "^(%b<>)().-(%b<>)()$";
          change = {
            target = "^<([^>]*)().-([^/]*)()>$";
            replacement.__raw = ''
              function()
                  local user_input = M.get_input("Enter the HTML tag: ")
                  if user_input then
                      local element = user_input:match("^<?([^%s>]*)")
                      local attributes = user_input:match("^<?[^%s>]*%s+(.-)>?$")

                      local open = attributes and element .. " " .. attributes or element
                      local close = element

                      return { { open }, { close } }
                  end
              end
            '';
          };
        };

        "f" = {
          add = ''
            function()
                local result = M.get_input("Enter the function name: ")
                if result then
                    return { { result .. "(" }, { ")" } }
                end
            end
          '';
          find.__raw = ''
            function()
                if vim.g.loaded_nvim_treesitter then
                    local selection = M.get_selection({
                        query = {
                            capture = "@call.outer",
                            type = "textobjects",
                        },
                    })
                    if selection then
                        return selection
                    end
                end
                return M.get_selection({ pattern = "[^=%s%(%){}]+%b()" })
            end
          '';
          delete = "^(.-%()().-(%))()$";
          change = {
            target = "^.-([%w_]+)()%(.-%)()()$";
            replacement.__raw = ''
              function()
                  local result = M.get_input("Enter the function name: ")
                  if result then
                      return { { result }, { "" } }
                  end
              end
            '';
          };
        };

        invalid_key_behavior = {
          add = ''
            function(char)
                if not char or char:find("%c") then
                    return nil
                end
                return { { char }, { char } }
            end
          '';
          find.__raw = ''
            function(char)
                if not char or char:find("%c") then
                    return nil
                end
                return M.get_selection({
                    pattern = vim.pesc(char) .. ".-" .. vim.pesc(char),
                })
            end
          '';
          delete.__raw = ''
            function(char)
                if not char or char:find("%c") then
                    return nil
                end
                return M.get_selections({
                    char = char,
                    pattern = "^(.)().-(.)()$",
                })
            end
          '';
        };
      };

      aliases = {
        "a" = ">";
        "b" = ")";
        "B" = "}";
        "r" = "]";
        "q" = ["\"" "'" "`"];
        "s" = ["}" "]" ")" ">" "\"" "'" "`"];
      };
    };
  }
