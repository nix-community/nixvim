{
  empty = {
    plugins.hex.enable = true;
  };

  defaults = {
    plugins.hex = {
      enable = true;

      settings = {
        dump_cmd = "xxd -g 1 -u";
        assemble_cmd = "xxd -r";
        is_buf_binary_pre_read.__raw = ''
          function()
            binary_ext = { 'out', 'bin', 'png', 'jpg', 'jpeg', 'exe', 'dll' }
            -- only work on normal buffers
            if vim.bo.ft ~= "" then return false end
            -- check -b flag
            if vim.bo.bin then return true end
            -- check ext within binary_ext
            local filename = vim.fn.expand('%:t')
            local ext = vim.fn.expand('%:e')
            if vim.tbl_contains(binary_ext, ext) then return true end
            -- none of the above
            return false
          end
        '';
        is_buf_binary_post_read.__raw = ''
          function()
              local encoding = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
              if encoding ~= 'utf-8' then return true end
              return false
            end
        '';
      };
    };
  };
}
