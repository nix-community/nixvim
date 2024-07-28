{ pkgs, ... }:
{
  combine-plugins = {
    performance.combinePlugins.enable = true;

    plugins.treesitter.enable = true;

    extraConfigLuaPost = ''
      -- Ensure that queries from nvim-treesitter are first in rtp
      local queries_path = "${pkgs.vimPlugins.nvim-treesitter}/queries"
      for name, type in vim.fs.dir(queries_path, {depth = 10}) do
        if type == "file" then
          -- Resolve all symlinks and compare nvim-treesitter's path with
          -- whatever we've got from runtime
          local nvim_treesitter_path = assert(vim.uv.fs_realpath(vim.fs.joinpath(queries_path, name)))
          local rtp_path = assert(
            vim.uv.fs_realpath(vim.api.nvim_get_runtime_file("queries/" .. name, false)[1]),
            name .. " not found in runtime"
          )
          assert(
            nvim_treesitter_path == rtp_path,
            string.format(
              "%s from rtp (%s) is not the same as from nvim-treesitter (%s)",
              name,
              rtp_path, nvim_treesitter_path
            )
          )
        end
      end
    '';
  };
}
