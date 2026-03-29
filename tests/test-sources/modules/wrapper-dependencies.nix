let
  mkLuaPathAssertions = moduleName: ''
    local function split_semicolon_list(value)
      local result = {}
      for entry in string.gmatch(value or "", "[^;]+") do
        table.insert(result, entry)
      end
      return result
    end

    local function resolve_module(module_name, search_path)
      local module_path = module_name:gsub("%.", "/")
      for _, entry in ipairs(split_semicolon_list(search_path)) do
        local candidate = entry:gsub("%?", module_path)
        if vim.uv.fs_stat(candidate) then
          return candidate
        end
      end
    end

    local function assert_env_path_visible(env_name, runtime_value)
      local env_value = vim.env[env_name]
      assert(type(env_value) == "string", env_name .. " is unset")

      local entries = split_semicolon_list(env_value)
      assert(#entries > 0, env_name .. " has no non-empty entries")

      for _, entry in ipairs(entries) do
        assert(
          runtime_value:find(entry, 1, true),
          string.format(
            "expected %s entry %q to be visible in runtime search path",
            env_name,
            entry
          )
        )
      end
    end

    assert_env_path_visible("LUA_PATH", package.path)
    assert_env_path_visible("LUA_CPATH", package.cpath)
    assert(
      resolve_module(${builtins.toJSON moduleName}, vim.env.LUA_PATH),
      string.format("Unable to resolve %q via LUA_PATH", ${builtins.toJSON moduleName})
    )
    assert(
      resolve_module(${builtins.toJSON moduleName}, package.path),
      string.format("Unable to resolve %q via package.path", ${builtins.toJSON moduleName})
    )
  '';
in
{
  telescope = {
    plugins.web-devicons.enable = true;
    plugins.telescope.enable = true;

    extraConfigLuaPost = mkLuaPathAssertions "plenary.strings" + ''
      local strings = require("plenary.strings")
      assert(type(strings.truncate) == "function", "plenary.strings.truncate is unavailable")
    '';
  };

  neorg = {
    plugins.treesitter.enable = true;
    plugins.neorg.enable = true;

    extraConfigLuaPost = mkLuaPathAssertions "lua-utils" + ''require("lua-utils")'';
  };
}
