{ lib }:
{
  example =
    { config, ... }:
    {
      userCommands = {
        "W" = {
          command = ":w<CR>";
          desc = "Write file";
          nargs = 0;
        };
        "Z" = {
          command = ":echo fooo<CR>";
        };
        "InsertHere" = {
          command.__raw = ''
            function(opts)
              vim.api.nvim_put({opts.args}, 'c', true, true)
            end
          '';
          nargs = 1;
        };
        "PreviewHere" = {
          command = ":echo fooo<CR>";
          nargs = 1;
          preview = ''
            function(opts, ns, buf)
              if buf then
                vim.api.nvim_buf_set_lines(buf, 0, -1, false, { opts.args })
              end
              return 2
            end
          '';
        };
      };

      assertions = [
        {
          assertion = lib.hasInfix "preview = function(opts, ns, buf)" config.extraConfigLua;
          message = "`userCommands.PreviewHere.preview` should be emitted as a lua function.";
        }
      ];
    };
}
