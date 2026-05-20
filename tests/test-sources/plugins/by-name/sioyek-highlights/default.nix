{ lib }:
{
  empty = {
    plugins.sioyek-highlights.enable = true;
  };

  defaults = {
    plugins.sioyek-highlights = {
      enable = true;
      settings = {
        db_path = lib.nixvim.mkRaw ''vim.fn.expand("~/.local/share/sioyek/shared.db")'';
        format_function = lib.nixvim.mkRaw ''
          function(text)
            local lines = vim.split(text, '\n', { plain = true })
            local formatted_lines = {}
            if #lines > 0 then
              lines[1] = '> *"' .. lines[1]
              lines[#lines] = lines[#lines] .. '"*'
              for i, line in ipairs(lines) do
                if i > 1 then
                  table.insert(formatted_lines, '> ' .. line)
                else
                  table.insert(formatted_lines, line)
                end
              end
            end
            return formatted_lines
          end
        '';
      };
    };
  };

  example = {
    plugins.sioyek-highlights = {
      enable = true;
      settings = {
        db_path = "/srv/notes/sioyek.db";
        format_function = lib.nixvim.mkRaw ''
          function(text)
            return vim.tbl_map(function(line)
              return "> " .. line
            end, vim.split(text, "\n", { plain = true }))
          end
        '';
      };
    };
  };
}
