{
  combine-plugins =
    { config, ... }:
    {
      performance.combinePlugins.enable = true;

      plugins.treesitter = {
        enable = true;

        # Exclude nixvim injections for test to pass
        nixvimInjections = false;
      };

      extraConfigLuaPost = ''
        -- Ensure that queries from nvim-treesitter are first in rtp
        local queries_path = "${config.plugins.treesitter.package}/queries"
        for name, type in vim.fs.dir(queries_path, {depth = 10}) do
          if type == "file" then
            -- Get the file from rtp, resolve all symlinks and check
            -- that the file is from nvim-treesitter. Only name is compared,
            -- because 'combinePlugins' overrides packages.
            local rtp_path = assert(
              vim.uv.fs_realpath(vim.api.nvim_get_runtime_file("queries/" .. name, false)[1]),
              name .. " not found in runtime"
            )
            assert(
              rtp_path:find("nvim-treesitter", 1, true),
              string.format(
                "%s from rtp (%s) is not from nvim-treesitter",
                name,
                rtp_path
              )
            )
          end
        end
      '';
    };
}
