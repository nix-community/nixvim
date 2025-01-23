{
  empty = {
    plugins.gx.enable = true;
  };

  default = {
    plugins.gx = {
      enable = true;

      disableNetrwGx = true;

      settings = {
        open_browser_app = null;
        open_browser_args = [ ];
        handlers = { };
        handler_options = {
          search_engine = "google";
          select_for_search = false;
          git_remotes = [
            "upstream"
            "origin"
          ];
          git_remote_push = false;
        };
      };
    };
  };

  example = {
    plugins.gx = {
      enable = true;

      settings = {
        handlers = {
          rust = {
            name = "rust";
            filetype = [ "toml" ];
            filename = "Cargo.toml";
            handle.__raw = ''
              function(mode, line, _)
                local crate = require("gx.helper").find(line, mode, "(%w+)%s-=%s")

                if crate then
                  return "https://crates.io/crates/" .. crate
                end
              end
            '';
          };
        };
        handler_options = {
          search_engine = "duckduckgo";
          git_remotes.__raw = ''
            function(fname)
              if fname:match("myproject") then
                  return { "mygit" }
              end
              return { "upstream", "origin" }
            end
          '';
        };
      };
    };
  };
}
