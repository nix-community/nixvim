{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "bufdelete";
  package = "bufdelete-nvim";
  globalPrefix = "bufdelete_";

  maintainers = [ lib.maintainers.MattSturgeon ];

  description = ''
    Delete Neovim buffers without losing window layout.

    ---

    This plugin provides two commands, `:Bdelete` and `:Bwipeout`.
    They work exactly the same as `:bdelete` and `:bwipeout`,
    except they keep your window layout intact.

    There's also two Lua functions provided, `bufdelete` and `bufwipeout`,
    which do the same thing as their command counterparts.
    Both take three arguments, `buffers`, `force` and `switchable_buffers`.

    Here's an example of how to use the functions:

    ```lua
      -- Forcibly delete current buffer
      require('bufdelete').bufdelete(0, true)

      -- Wipeout buffer number 100 without force
      require('bufdelete').bufwipeout(100)

      -- Delete buffer 7 and 30 without force.
      require('bufdelete').bufdelete({7, 30})

      -- Delete buffer matching foo.txt with force
      require('bufdelete').bufdelete("foo.txt", true)

      -- Delete buffer matching foo.txt, buffer matching bar.txt and buffer 3 with force
      require('bufdelete').bufdelete({"foo.txt", "bar.txt", 3}, true)

      -- Delete current buffer and switch to one of buffer 3, 5 or 10
      require('bufdelete').bufdelete(0, false, { 3, 5, 10 })
    ```

    See the plugin's [README] for more details.

    [README]: https://github.com/famiu/bufdelete.nvim/?tab=readme-ov-file
  '';

  settingsOptions = {
    buf_filter = lib.nixvim.defaultNullOpts.mkLuaFn null ''
      Function that determines buffers that bufdelete.nvim can switch to,
      instead of the default behavior of switching to any buffer.

      Must be a function that takes no argument and returns a list of buffers.
    '';
  };

  settingsExample = {
    buf_filter = ''
      function()
        -- TODO: return a list of buffers
        return { }
      end
    '';
  };
}
