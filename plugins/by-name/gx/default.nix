{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "gx";
  packPathName = "gx.nvim";
  package = "gx-nvim";
  description = ''
    Implementation of gx without the need of netrw.
  '';

  maintainers = [ lib.maintainers.jolars ];

  extraOptions = {
    disableNetrwGx = lib.mkOption {
      default = true;
      description = "Disable the `gx` mapping in netrw.";
      type = types.bool;
    };
  };

  extraConfig = cfg: {
    globals = lib.mkIf cfg.disableNetrwGx {
      netrw_nogx = lib.mkDefault true;
    };
  };

  settingsOptions = {
    open_browser_app = defaultNullOpts.mkStr null ''
      Specify your browser app; default for macOS is `"open"`, Linux `"xdg-open"`
      and Windows `"powershell.exe"`.
    '';

    open_browser_args = defaultNullOpts.mkListOf types.str [ ] ''
      Arguments provided to the browser app, such as `--background` for macOS's `open`.
    '';

    handlers = defaultNullOpts.mkAttrsOf types.anything { } ''
      Enable built-in handlers and configure custom ones. By default, all
      handlers are disabled. To enable a built-in handler, set it to `true`.
    '';

    handler_options = {
      search_engine = defaultNullOpts.mkStr "google" ''
        Search engine to use when searching for text. Built-in options are
        `"google"`, `"duckduckgo"`, `"ecosia"`, `"yandex"`, and `"bing"`. You
        can also pass a custom search engine, such as
        `"https://search.brave.com/search?q="`.
      '';

      select_for_search = defaultNullOpts.mkBool false ''
        If your cursor is e.g. on a link, the pattern for the link AND for the word
        will always match. This disables this behaviour for default so that the link is
        opened without the select option for the word AND link.
      '';

      git_remotes = defaultNullOpts.mkListOf' {
        type = types.str;
        pluginDefault = [
          "upstream"
          "origin"
        ];
        description = ''
          List of git remotes to search for git issue linking, in priority.
          You can also pass a function.
        '';
        example = lib.nixvim.literalLua ''
          function(fname)
            if fname:match("myproject") then
              return { "mygit" }
            end
            return { "upstream", "origin" }
          end
        '';
      };

      git_remote_push = defaultNullOpts.mkBool' {
        type = types.bool;
        pluginDefault = false;
        description = ''
          Whether to use the push url for git issue linking.
          You can also pass a function.
        '';
        example = lib.nixvim.literalLua ''
          function(fname)
            return fname:match("myproject")
          end
        '';
      };
    };
  };

  settingsExample = lib.literalExpression ''
    {
      open_browser_args = [ "--background" ];
      handlers = {
        rust = {
          name = "rust";
          filetype = [ "toml" ];
          filename = "Cargo.toml";
          handle.__raw = '''
            function(mode, line, _)
              local crate = require("gx.helper").find(line, mode, "(%w+)%s-=%s")

              if crate then
                return "https://crates.io/crates/" .. crate
              end
            end
          ''';
        };
      };
      handler_options = {
        search_engine = "duckduckgo";
        git_remotes = [
          "origin"
        ];
      };
    };
  '';
}
