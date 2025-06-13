{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "snacks";
  packPathName = "snacks.nvim";
  package = "snacks-nvim";

  description = ''
    A collection of small QoL plugins for Neovim.
  '';

  maintainers = [
    lib.maintainers.adeci
    lib.maintainers.HeitorAugustoLN
  ];

  # Override the startup section to avoid lazy.nvim dependency
  extraConfig = cfg: {
    extraConfigLuaPre = ''
      -- Store the startup time when this code runs (very early in init)
      _G._nixvim_snacks_start_time = vim.fn.reltime()
      -- Provide a mock lazy.stats module for snacks.nvim compatibility
      -- This prevents errors when the dashboard startup section tries to load it
      package.preload["lazy.stats"] = function()
        return {
          stats = function()
            -- Calculate actual startup time from our stored start time
            local startuptime = 100 -- Default fallback
            if _G._nixvim_snacks_start_time then
              startuptime = vim.fn.reltimefloat(vim.fn.reltime(_G._nixvim_snacks_start_time)) * 1000
            end
            -- Return mock stats that match what snacks expects
            return {
              startuptime = startuptime, -- Time in milliseconds since Neovim started
              count = vim.tbl_count(package.loaded),  -- Approximate plugin count
              loaded = vim.tbl_count(package.loaded), -- Same as count for simplicity
            }
          end
        }
      end
    '';
  };

  settingsOptions = {
    animate = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable the animation library.
        Provides efficient animations with over 45 easing functions.

        Animations can be globally disabled by setting:
        - vim.g.snacks_animate = false (globally)
        - vim.b.snacks_animate = false (per buffer)
      '';

      duration = defaultNullOpts.mkAttrsOf types.anything 20 ''
        Duration settings for animations. Can be:
        - A number: duration per step in milliseconds
        - A table with:
          - step: duration per step in ms
          - total: total duration in ms
        When both step and total are specified, the minimum is used.
      '';

      easing =
        defaultNullOpts.mkEnumFirstDefault
          [
            "linear"
            "inQuad"
            "outQuad"
            "inOutQuad"
            "outInQuad"
            "inCubic"
            "outCubic"
            "inOutCubic"
            "outInCubic"
            "inQuart"
            "outQuart"
            "inOutQuart"
            "outInQuart"
            "inQuint"
            "outQuint"
            "inOutQuint"
            "outInQuint"
            "inSine"
            "outSine"
            "inOutSine"
            "outInSine"
            "inExpo"
            "outExpo"
            "inOutExpo"
            "outInExpo"
            "inCirc"
            "outCirc"
            "inOutCirc"
            "outInCirc"
            "inElastic"
            "outElastic"
            "inOutElastic"
            "outInElastic"
            "inBack"
            "outBack"
            "inOutBack"
            "outInBack"
            "inBounce"
            "outBounce"
            "inOutBounce"
            "outInBounce"
          ]
          ''
            Easing function to use for animations.
            Choose from over 45 different easing functions.
            Can also be a custom easing function.
          '';

      fps = defaultNullOpts.mkNum 60 ''
        Frames per second for animations.
        This is a global setting that controls all animations.
        Higher values provide smoother animations but use more CPU.
      '';
    };
    bigfile = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable `bigfile` plugin.
      '';

      notify = defaultNullOpts.mkBool true ''
        Whether to show notification when big file detected.
      '';

      size = defaultNullOpts.mkNum { __raw = "1.5 * 1024 * 1024"; } ''
        The size at which a file is considered big.
      '';

      setup =
        defaultNullOpts.mkRaw
          ''
            function(ctx)
              vim.b.minianimate_disable = true
              vim.schedule(function()
                vim.bo[ctx.buf].syntax = ctx.ft
              end)
            end
          ''
          ''
            Enable or disable features when a big file is detected.
          '';
    };

    bufdelete = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable smart buffer deletion.
        Delete buffers without disrupting window layout.
      '';
    };

    dashboard = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable `dashboard` plugin.
      '';

      width = defaultNullOpts.mkNum 60 ''
        Dashboard width.
      '';

      row = defaultNullOpts.mkNum null ''
        Dashboard position (row). nil for center.
      '';

      col = defaultNullOpts.mkNum null ''
        Dashboard position (col). nil for center.
      '';

      pane_gap = defaultNullOpts.mkNum 4 ''
        Empty columns between vertical panes.
      '';

      autokeys = defaultNullOpts.mkStr "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" ''
        Autokey sequence.
      '';

      preset = {
        pick = defaultNullOpts.mkRaw null ''
          Picker function. Defaults to a picker that supports fzf-lua, telescope.nvim and mini.pick.
        '';

        keys =
          defaultNullOpts.mkListOf (types.attrsOf types.anything)
            [
              {
                icon = " ";
                key = "f";
                desc = "Find File";
                action = ":lua Snacks.dashboard.pick('files')";
              }
              {
                icon = " ";
                key = "n";
                desc = "New File";
                action = ":ene | startinsert";
              }
              {
                icon = " ";
                key = "g";
                desc = "Find Text";
                action = ":lua Snacks.dashboard.pick('live_grep')";
              }
              {
                icon = " ";
                key = "r";
                desc = "Recent Files";
                action = ":lua Snacks.dashboard.pick('oldfiles')";
              }
              {
                icon = " ";
                key = "c";
                desc = "Config";
                action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})";
              }
              {
                icon = " ";
                key = "s";
                desc = "Restore Session";
                section = "session";
              }
              {
                icon = " ";
                key = "q";
                desc = "Quit";
                action = ":qa";
              }
            ]
            ''
              Default keymaps configuration.
            '';

        header =
          defaultNullOpts.mkStr
            ''
              ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
              ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
              ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
              ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
              ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
              ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
            ''
            ''
              Header text for the dashboard.
            '';
      };

      formats =
        defaultNullOpts.mkAttrsOf types.anything
          {
            icon = {
              __raw = ''
                function(item)
                  if item.file and item.icon == "file" or item.icon == "directory" then
                    return M.icon(item.file, item.icon)
                  end
                  return { item.icon, width = 2, hl = "icon" }
                end
              '';
            };
            footer = [
              "%s"
              { align = "center"; }
            ];
            header = [
              "%s"
              { align = "center"; }
            ];
            file = {
              __raw = ''
                function(item, ctx)
                  local fname = vim.fn.fnamemodify(item.file, ":~")
                  fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
                  if #fname > ctx.width then
                    local dir = vim.fn.fnamemodify(fname, ":h")
                    local file = vim.fn.fnamemodify(fname, ":t")
                    if dir and file then
                      file = file:sub(-(ctx.width - #dir - 2))
                      fname = dir .. "/…" .. file
                    end
                  end
                  local dir, file = fname:match("^(.*)/(.+)$")
                  return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
                end
              '';
            };
          }
          ''
            Item field formatters.
          '';

      sections =
        defaultNullOpts.mkListOf (types.attrsOf types.anything)
          [
            { section = "header"; }
            {
              section = "keys";
              gap = 1;
              padding = 1;
            }
            { section = "startup"; }
          ]
          ''
            Dashboard sections configuration.
          '';
    };

    debug = {
      enabled = defaultNullOpts.mkBool false ''
        Whether to enable the debug utilities.
        Provides pretty inspect, backtraces, profiling, and other debugging tools.

        Note: This plugin provides utility functions rather than automatic features.
        You may want to set up global functions in your config:

        _G.dd = function(...) Snacks.debug.inspect(...) end
        _G.bt = function() Snacks.debug.backtrace() end
        vim.print = _G.dd
      '';
    };

    dim = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable scope dimming.
        Focus on the active scope by dimming the rest.
      '';

      scope =
        defaultNullOpts.mkAttrsOf types.anything
          {
            min_size = 5;
            max_size = 20;
            siblings = true;
          }
          ''
            Configuration for scope detection.
            min_size: minimum lines in a scope
            max_size: maximum lines in a scope
            siblings: include sibling scopes
          '';

      animate =
        defaultNullOpts.mkAttrsOf types.anything
          {
            enabled = {
              __raw = ''vim.fn.has("nvim-0.10") == 1'';
            };
            easing = "outQuad";
            duration = {
              step = 20;
              total = 300;
            };
          }
          ''
            Animation configuration for scope transitions.
            Enabled by default for Neovim >= 0.10.
            Works on older versions but has to trigger redraws during animation.
          '';

      filter =
        defaultNullOpts.mkRaw
          ''
            function(buf)
              return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == ""
            end
          ''
          ''
            Function to determine which buffers should be dimmed.
            Default: only dim normal buffers when dimming is not disabled globally or per-buffer.
          '';
    };

    explorer = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable `explorer` plugin.
      '';

      replace_netrw = defaultNullOpts.mkBool true ''
        Replace netrw with the snacks explorer.
      '';
    };

    git = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable git utilities.
        Provides git blame and root detection functionality.
      '';
    };

    gitbrowse = {
      enabled = defaultNullOpts.mkBool false ''
        Whether to enable the gitbrowse plugin.
        Opens the current file, branch, commit, or repo in a browser (e.g. GitHub, GitLab, Bitbucket).
      '';

      notify = defaultNullOpts.mkBool true ''
        Whether to show notification when opening the browser.
      '';

      open =
        defaultNullOpts.mkRaw
          ''
            function(url)
              if vim.fn.has("nvim-0.10") == 0 then
                require("lazy.util").open(url, { system = true })
                return
              end
              vim.ui.open(url)
            end
          ''
          ''
            Handler function to open the URL in a browser.
            Defaults to using vim.ui.open on Neovim 0.10+ or lazy.util.open for older versions.
          '';

      what = defaultNullOpts.mkEnumFirstDefault [ "commit" "repo" "branch" "file" "permalink" ] ''
        What to open in the browser. Not all remotes support all types.
        - "repo": Open the repository homepage
        - "branch": Open the current branch
        - "file": Open the current file at the current branch
        - "commit": Open the commit under cursor if valid, otherwise the file
        - "permalink": Open the current file at its last commit
      '';

      branch = defaultNullOpts.mkStr null ''
        Override the branch to open. If not specified, uses the current branch.
      '';

      line_start = defaultNullOpts.mkNum null ''
        Starting line number for line range selection. 
        If not specified, uses current cursor position or visual selection.
      '';

      line_end = defaultNullOpts.mkNum null ''
        Ending line number for line range selection.
        If not specified, uses current cursor position or visual selection.
      '';

      remote_patterns =
        defaultNullOpts.mkListOf (types.listOf types.str)
          [
            [
              "^(https?://.*)%.git$"
              "%1"
            ]
            [
              "^git@(.+):(.+)%.git$"
              "https://%1/%2"
            ]
            [
              "^git@(.+):(.+)$"
              "https://%1/%2"
            ]
            [
              "^git@(.+)/(.+)$"
              "https://%1/%2"
            ]
            [
              "^org%-%d+@(.+):(.+)%.git$"
              "https://%1/%2"
            ]
            [
              "^ssh://git@(.*)$"
              "https://%1"
            ]
            [
              "^ssh://([^:/]+)(:%d+)/(.*)$"
              "https://%1/%3"
            ]
            [
              "^ssh://([^/]+)/(.*)$"
              "https://%1/%2"
            ]
            [
              "ssh%.dev%.azure%.com/v3/(.*)/(.*)$"
              "dev.azure.com/%1/_git/%2"
            ]
            [
              "^https://%w*@(.*)"
              "https://%1"
            ]
            [
              "^git@(.*)"
              "https://%1"
            ]
            [
              ":%d+"
              ""
            ]
            [
              "%.git$"
              ""
            ]
          ]
          ''
            List of patterns to transform git remotes into URLs.
            Each pattern is a list of two strings: [match_pattern, replacement].
          '';

      url_patterns =
        defaultNullOpts.mkAttrsOf (types.attrsOf types.str)
          {
            "github%.com" = {
              branch = "/tree/{branch}";
              file = "/blob/{branch}/{file}#L{line_start}-L{line_end}";
              permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}";
              commit = "/commit/{commit}";
            };
            "gitlab%.com" = {
              branch = "/-/tree/{branch}";
              file = "/-/blob/{branch}/{file}#L{line_start}-L{line_end}";
              permalink = "/-/blob/{commit}/{file}#L{line_start}-L{line_end}";
              commit = "/-/commit/{commit}";
            };
            "bitbucket%.org" = {
              branch = "/src/{branch}";
              file = "/src/{branch}/{file}#lines-{line_start}-L{line_end}";
              permalink = "/src/{commit}/{file}#lines-{line_start}-L{line_end}";
              commit = "/commits/{commit}";
            };
            "git.sr.ht" = {
              branch = "/tree/{branch}";
              file = "/tree/{branch}/item/{file}";
              permalink = "/tree/{commit}/item/{file}#L{line_start}";
              commit = "/commit/{commit}";
            };
          }
          ''
            URL patterns for different git hosting services.
            Maps service domains to URL templates for different browse types.
            Templates use {field} placeholders that get replaced with actual values.

            Note: While the upstream plugin supports functions as values,
            in nixvim you should use string templates. For advanced use cases
            requiring functions, you can use the __raw attribute to pass Lua code.
          '';
    };

    image = {
      enabled = defaultNullOpts.mkBool true ''
        Enable image viewer using Kitty Graphics Protocol.
      '';

      formats =
        defaultNullOpts.mkListOf types.str
          [
            "png"
            "jpg"
            "jpeg"
            "gif"
            "bmp"
            "webp"
            "tiff"
            "heic"
            "avif"
            "mp4"
            "mov"
            "avi"
            "mkv"
            "webm"
            "pdf"
          ]
          ''
            Supported image formats.
          '';

      force = defaultNullOpts.mkBool false ''
        Try displaying the image, even if the terminal does not support it.
      '';

      doc = {
        enabled = defaultNullOpts.mkBool true ''
          Enable image viewer for documents. A treesitter parser must be available for enabled languages.
        '';

        inline = defaultNullOpts.mkBool true ''
          Render the image inline in the buffer. Takes precedence over float on supported terminals.
        '';

        float = defaultNullOpts.mkBool true ''
          Render the image in a floating window. Only used if inline is disabled.
        '';

        max_width = defaultNullOpts.mkNum 80 ''
          Maximum width for document images.
        '';

        max_height = defaultNullOpts.mkNum 40 ''
          Maximum height for document images.
        '';

        conceal =
          defaultNullOpts.mkRaw
            ''
              function(lang, type)
                -- only conceal math expressions
                return type == "math"
              end
            ''
            ''
              Function to determine if image text should be concealed when rendering inline.
            '';
      };

      img_dirs =
        defaultNullOpts.mkListOf types.str
          [
            "img"
            "images"
            "assets"
            "static"
            "public"
            "media"
            "attachments"
          ]
          ''
            Directories to search for images.
          '';

      wo =
        defaultNullOpts.mkAttrsOf types.anything
          {
            wrap = false;
            number = false;
            relativenumber = false;
            cursorcolumn = false;
            signcolumn = "no";
            foldcolumn = "0";
            list = false;
            spell = false;
            statuscolumn = "";
          }
          ''
            Window options for windows showing image buffers.
          '';

      bo = defaultNullOpts.mkAttrsOf types.anything { } ''
        Buffer options for the image buffer.
      '';

      cache = defaultNullOpts.mkRaw ''vim.fn.stdpath("cache") .. "/snacks/image"'' ''
        Cache directory for converted images.
      '';

      debug = {
        request = defaultNullOpts.mkBool false ''
          Debug image requests.
        '';

        convert = defaultNullOpts.mkBool false ''
          Debug image conversion.
        '';

        placement = defaultNullOpts.mkBool false ''
          Debug image placement.
        '';
      };

      env = defaultNullOpts.mkAttrsOf types.anything { } ''
        Environment variables to control image behavior.
      '';

      icons = {
        math = defaultNullOpts.mkStr "󰪚 " ''
          Icon for math expressions.
        '';

        chart = defaultNullOpts.mkStr "󰄧 " ''
          Icon for charts.
        '';

        image = defaultNullOpts.mkStr " " ''
          Icon for images.
        '';
      };

      convert = {
        notify = defaultNullOpts.mkBool true ''
          Show a notification on conversion error.
        '';

        mermaid =
          defaultNullOpts.mkRaw
            ''
              function()
                local theme = vim.o.background == "light" and "neutral" or "dark"
                return { "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", theme, "-s", "{scale}" }
              end
            ''
            ''
              Mermaid conversion arguments function.
            '';

        magick = {
          default = defaultNullOpts.mkListOf types.str [ "{src}[0]" "-scale" "1920x1080>" ] ''
            Default ImageMagick arguments for raster images.
          '';

          vector = defaultNullOpts.mkListOf types.str [ "-density" "192" "{src}[0]" ] ''
            ImageMagick arguments for vector images like SVG.
          '';

          math = defaultNullOpts.mkListOf types.str [ "-density" "192" "{src}[0]" "-trim" ] ''
            ImageMagick arguments for math expressions.
          '';

          pdf =
            defaultNullOpts.mkListOf types.str
              [
                "-density"
                "192"
                "{src}[0]"
                "-background"
                "white"
                "-alpha"
                "remove"
                "-trim"
              ]
              ''
                ImageMagick arguments for PDF conversion.
              '';
        };
      };

      math = {
        enabled = defaultNullOpts.mkBool true ''
          Enable math expression rendering.
        '';

        typst = {
          tpl =
            defaultNullOpts.mkStr
              ''
                #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
                #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
                #set text(size: 12pt, fill: rgb("''${color}"))
                ''${header}
                ''${content}''
              ''
                Typst template for math expressions.
              '';
        };

        latex = {
          font_size = defaultNullOpts.mkStr "Large" ''
            LaTeX font size for math expressions. See https://www.sascha-frank.com/latex-font-size.html
          '';

          packages =
            defaultNullOpts.mkListOf types.str [ "amsmath" "amssymb" "amsfonts" "amscd" "mathtools" ]
              ''
                LaTeX packages to include for math expressions.
              '';

          tpl =
            defaultNullOpts.mkStr
              ''
                \documentclass[preview,border=0pt,varwidth,12pt]{standalone}
                \usepackage{''${packages}}
                \begin{document}
                ''${header}
                { \''${font_size} \selectfont
                  \color[HTML]{''${color}}
                ''${content}}
                \end{document}''
              ''
                LaTeX template for math expressions.
              '';
        };
      };

      resolve = defaultNullOpts.mkRaw null ''
        Function to resolve image references in files.
        Return the absolute path or url to the image.
        When nil, the path is resolved relative to the file.
      '';
    };

    indent = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable indent guides and scope highlighting.
      '';

      indent = {
        priority = defaultNullOpts.mkNum 1 ''
          Priority of indent guides.
        '';

        enabled = defaultNullOpts.mkBool true ''
          Enable indent guides.
        '';

        char = defaultNullOpts.mkStr "│" ''
          Character to use for indent guides.
        '';

        only_scope = defaultNullOpts.mkBool false ''
          Only show indent guides of the scope.
        '';

        only_current = defaultNullOpts.mkBool false ''
          Only show indent guides in the current window.
        '';

        hl = defaultNullOpts.mkAttrsOf types.anything "SnacksIndent" ''
          Highlight group(s) for indent guides.
          Can be a string or a list of highlight groups to cycle through.
        '';
      };

      animate = {
        enabled = defaultNullOpts.mkRaw "vim.fn.has('nvim-0.10') == 1" ''
          Enable scope animations. Enabled by default for Neovim >= 0.10.
        '';

        style = defaultNullOpts.mkEnumFirstDefault [ "out" "up_down" "down" "up" ] ''
          Animation style:
          - out: animate outwards from the cursor
          - up: animate upwards from the cursor
          - down: animate downwards from the cursor
          - up_down: animate up or down based on the cursor position
        '';

        easing = defaultNullOpts.mkStr "linear" ''
          Easing function for animations.
        '';

        duration = {
          step = defaultNullOpts.mkNum 20 ''
            Duration of each animation step in milliseconds.
          '';

          total = defaultNullOpts.mkNum 500 ''
            Maximum total animation duration in milliseconds.
          '';
        };
      };

      scope = {
        enabled = defaultNullOpts.mkBool true ''
          Enable highlighting the current scope.
        '';

        priority = defaultNullOpts.mkNum 200 ''
          Priority of scope highlighting.
        '';

        char = defaultNullOpts.mkStr "│" ''
          Character to use for scope guides.
        '';

        underline = defaultNullOpts.mkBool false ''
          Underline the start of the scope.
        '';

        only_current = defaultNullOpts.mkBool false ''
          Only show scope in the current window.
        '';

        hl = defaultNullOpts.mkAttrsOf types.anything "SnacksIndentScope" ''
          Highlight group(s) for scope.
        '';
      };

      chunk = {
        enabled = defaultNullOpts.mkBool false ''
          When enabled, scopes will be rendered as chunks, except for the
          top-level scope which will be rendered as a scope.
        '';

        only_current = defaultNullOpts.mkBool false ''
          Only show chunk scopes in the current window.
        '';

        priority = defaultNullOpts.mkNum 200 ''
          Priority of chunk rendering.
        '';

        hl = defaultNullOpts.mkAttrsOf types.anything "SnacksIndentChunk" ''
          Highlight group(s) for chunk scopes.
        '';

        char = {
          corner_top = defaultNullOpts.mkStr "┌" ''
            Character for top corner of chunk.
          '';

          corner_bottom = defaultNullOpts.mkStr "└" ''
            Character for bottom corner of chunk.
          '';

          horizontal = defaultNullOpts.mkStr "─" ''
            Character for horizontal lines in chunk.
          '';

          vertical = defaultNullOpts.mkStr "│" ''
            Character for vertical lines in chunk.
          '';

          arrow = defaultNullOpts.mkStr ">" ''
            Character for arrow in chunk.
          '';
        };
      };

      filter =
        defaultNullOpts.mkRaw
          ''
            function(buf)
              return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
            end
          ''
          ''
            Filter function for buffers to enable indent guides.
          '';

      debug = defaultNullOpts.mkBool false ''
        Enable debug mode for indent guides.
      '';
    };

    input = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable enhanced `vim.ui.input`.
        When enabled, replaces the default vim input dialog with a floating window.
      '';

      icon = defaultNullOpts.mkStr " " ''
        Icon to show in the input window.
      '';

      icon_hl = defaultNullOpts.mkStr "SnacksInputIcon" ''
        Highlight group for the icon.
      '';

      icon_pos = defaultNullOpts.mkEnumFirstDefault [ "left" "title" false ] ''
        Position of the icon.
        - "left": Show icon on the left side of the input
        - "title": Show icon in the window title
        - false: Don't show icon
      '';

      prompt_pos = defaultNullOpts.mkEnumFirstDefault [ "title" "left" false ] ''
        Position of the prompt text.
        - "title": Show prompt in the window title
        - "left": Show prompt on the left side of the input
        - false: Don't show prompt
      '';

      win = defaultNullOpts.mkRaw "{style = \"input\"}" ''
        Window configuration. Uses the snacks window system.
        Can specify a style from the styles table or a full window configuration.
      '';

      expand = defaultNullOpts.mkBool true ''
        Expand the width of the window based on the content length.
      '';
    };

    layout = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable the window layout library.
        Create complex window layouts with multiple windows arranged horizontally or vertically.
      '';

      show = defaultNullOpts.mkBool true ''
        Show the layout on creation.
      '';

      wins = defaultNullOpts.mkAttrsOf types.anything { } ''
        Windows to include in the layout.
        Each key is a window name, and the value is a snacks.win configuration.
      '';

      layout =
        defaultNullOpts.mkAttrsOf types.anything
          {
            width = 0.6;
            height = 0.6;
            zindex = 50;
          }
          ''
            Layout definition. Can be a box with horizontal/vertical orientation and children.
            The root layout box configuration.
          '';

      fullscreen = defaultNullOpts.mkBool false ''
        Open the layout in fullscreen mode.
      '';

      hidden = defaultNullOpts.mkListOf types.str [ ] ''
        List of window names that will be excluded from the layout but can be toggled.
      '';

      on_update = defaultNullOpts.mkRaw null ''
        Callback after updating the layout.
        Function signature: fun(layout: snacks.layout)
      '';

      on_update_pre = defaultNullOpts.mkRaw null ''
        Callback before updating the layout.
        Function signature: fun(layout: snacks.layout)
      '';
    };

    lazygit = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable LazyGit integration.
        Opens LazyGit in a float with automatic colorscheme configuration
        and Neovim edit integration.
      '';

      configure = defaultNullOpts.mkBool true ''
        Automatically configure lazygit to use the current colorscheme
        and integrate edit with the current neovim instance.
      '';

      config =
        defaultNullOpts.mkAttrsOf types.anything
          {
            os = {
              editPreset = "nvim-remote";
            };
            gui = {
              nerdFontsVersion = "3";
            };
          }
          ''
            Extra configuration for lazygit that will be merged with the default.
            Note: snacks does NOT have a full yaml parser, so if you need "test"
            to appear with quotes, you need to double quote it: "\"test\""
          '';

      theme_path = defaultNullOpts.mkRaw ''vim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml")'' ''
        Path where the generated theme file will be stored.
      '';

      theme =
        defaultNullOpts.mkAttrsOf (types.attrsOf types.anything)
          {
            "241" = {
              fg = "Special";
            };
            activeBorderColor = {
              fg = "MatchParen";
              bold = true;
            };
            cherryPickedCommitBgColor = {
              fg = "Identifier";
            };
            cherryPickedCommitFgColor = {
              fg = "Function";
            };
            defaultFgColor = {
              fg = "Normal";
            };
            inactiveBorderColor = {
              fg = "FloatBorder";
            };
            optionsTextColor = {
              fg = "Function";
            };
            searchingActiveBorderColor = {
              fg = "MatchParen";
              bold = true;
            };
            selectedLineBgColor = {
              bg = "Visual";
            };
            unstagedChangesColor = {
              fg = "DiagnosticError";
            };
          }
          ''
            Theme configuration for lazygit.
            Maps lazygit theme keys to Neovim highlight groups.
          '';

      win =
        defaultNullOpts.mkAttrsOf types.anything
          {
            style = "lazygit";
          }
          ''
            Window configuration for the lazygit terminal.
          '';

      args = defaultNullOpts.mkListOf types.str null ''
        Additional arguments to pass to lazygit.
      '';
    };

    notifier = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable `notifier` plugin.
      '';

      timeout = defaultNullOpts.mkUnsignedInt 3000 ''
        Timeout of notifier in milliseconds.
      '';

      width = {
        min = defaultNullOpts.mkNum 40 ''
          Minimum width of notification.
        '';

        max = defaultNullOpts.mkNum 0.4 ''
          Maximum width of notification.
        '';
      };

      height = {
        min = defaultNullOpts.mkNum 40 ''
          Minimum height of notification.
        '';

        max = defaultNullOpts.mkNum 0.4 ''
          Maximum height of notification.
        '';
      };

      margin = {
        top = defaultNullOpts.mkUnsignedInt 0 ''
          Top margin of notification.
        '';

        right = defaultNullOpts.mkUnsignedInt 1 ''
          Right margin of notification.
        '';

        bottom = defaultNullOpts.mkUnsignedInt 0 ''
          Bottom margin of notification.
        '';
      };
      padding = defaultNullOpts.mkBool true ''
        Whether to add 1 cell of left/right padding to the notification window.
      '';

      sort =
        defaultNullOpts.mkListOf types.str
          [
            "level"
            "added"
          ]
          ''
            How to sort notifications.
          '';

      icons = {
        error = defaultNullOpts.mkStr " " ''
          Icon for `error` notifications.
        '';

        warn = defaultNullOpts.mkStr " " ''
          Icon for `warn` notifications.
        '';

        info = defaultNullOpts.mkStr " " ''
          Icon for `info` notifications.
        '';

        debug = defaultNullOpts.mkStr " " ''
          Icon for `debug` notifications.
        '';

        trace = defaultNullOpts.mkStr " " ''
          Icon for `trace` notifications.
        '';
      };

      style =
        defaultNullOpts.mkEnum
          [
            "compact"
            "fancy"
            "minimal"
          ]
          "compact"
          ''
            Style of notifications.
          '';
      top_down = defaultNullOpts.mkBool true ''
        Whether to place notifications from top to bottom.
      '';

      date_format = defaultNullOpts.mkStr "%R" ''
        Time format for notifications.
      '';

      refresh = defaultNullOpts.mkUnsignedInt 50 ''
        Time in milliseconds to refresh notifications.
      '';
    };

    notify = {
      enabled = defaultNullOpts.mkBool true ''
        Enable notify utility functions.
        This provides utility functions to work with Neovim's vim.notify.
        The notify module doesn't have configuration options - it's a simple wrapper around vim.notify.
      '';
    };

    picker = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable `picker` plugin.
      '';

      prompt = defaultNullOpts.mkStr " " ''
        Prompt text / icon.
      '';

      sources = defaultNullOpts.mkAttrsOf (types.attrsOf types.anything) { } ''
        Source configurations.
      '';

      focus = defaultNullOpts.mkEnum [ "input" "list" ] "input" ''
        Where to focus when the picker is opened.
      '';

      layout = {
        cycle = defaultNullOpts.mkBool true ''
          Whether to cycle through the list.
        '';

        preset =
          defaultNullOpts.mkRaw
            ''
              function()
                return vim.o.columns >= 120 and "default" or "vertical"
              end
            ''
            ''
              Use the default layout or vertical if the window is too narrow.
            '';
      };

      matcher = {
        fuzzy = defaultNullOpts.mkBool true ''
          Use fuzzy matching.
        '';

        smartcase = defaultNullOpts.mkBool true ''
          Use smartcase.
        '';

        ignorecase = defaultNullOpts.mkBool true ''
          Use ignorecase.
        '';

        sort_empty = defaultNullOpts.mkBool false ''
          Sort results when the search string is empty.
        '';

        filename_bonus = defaultNullOpts.mkBool true ''
          Give bonus for matching file names.
        '';

        file_pos = defaultNullOpts.mkBool true ''
          Support patterns like `file:line:col` and `file:line`.
        '';

        cwd_bonus = defaultNullOpts.mkBool false ''
          Give bonus for matching files in the cwd.
        '';

        frecency = defaultNullOpts.mkBool false ''
          Frecency bonus.
        '';

        history_bonus = defaultNullOpts.mkBool false ''
          Give more weight to chronological order.
        '';
      };

      sort = {
        fields = defaultNullOpts.mkListOf types.str [ "score:desc" "#text" "idx" ] ''
          Default sort is by score, text length and index.
        '';
      };

      ui_select = defaultNullOpts.mkBool true ''
        Replace `vim.ui.select` with the snacks picker.
      '';

      formatters = {
        text = {
          ft = defaultNullOpts.mkStr null ''
            Filetype for highlighting.
          '';
        };

        file = {
          filename_first = defaultNullOpts.mkBool false ''
            Display filename before the file path.
          '';

          truncate = defaultNullOpts.mkNum 40 ''
            Truncate the file path to (roughly) this length.
          '';

          filename_only = defaultNullOpts.mkBool false ''
            Only show the filename.
          '';

          icon_width = defaultNullOpts.mkNum 2 ''
            Width of the icon (in characters).
          '';

          git_status_hl = defaultNullOpts.mkBool true ''
            Use the git status highlight group for the filename.
          '';
        };

        selected = {
          show_always = defaultNullOpts.mkBool false ''
            Only show the selected column when there are multiple selections.
          '';

          unselected = defaultNullOpts.mkBool true ''
            Use the unselected icon for unselected items.
          '';
        };

        severity = {
          icons = defaultNullOpts.mkBool true ''
            Show severity icons.
          '';

          level = defaultNullOpts.mkBool false ''
            Show severity level.
          '';

          pos = defaultNullOpts.mkEnum [ "left" "right" ] "left" ''
            Position of the diagnostics.
          '';
        };
      };

      previewers = {
        diff = {
          builtin = defaultNullOpts.mkBool true ''
            Use Neovim for previewing diffs or use an external tool.
          '';

          cmd = defaultNullOpts.mkListOf types.str [ "delta" ] ''
            External command for showing diffs.
          '';
        };

        git = {
          builtin = defaultNullOpts.mkBool true ''
            Use Neovim for previewing git output or use git.
          '';

          args = defaultNullOpts.mkListOf types.str [ ] ''
            Additional arguments passed to the git command.
          '';
        };

        file = {
          max_size = defaultNullOpts.mkNum (1024 * 1024) ''
            Maximum file size to preview (1MB).
          '';

          max_line_length = defaultNullOpts.mkNum 500 ''
            Max line length.
          '';

          ft = defaultNullOpts.mkStr null ''
            Filetype for highlighting. Use `nil` for auto detect.
          '';
        };

        man_pager = defaultNullOpts.mkStr null ''
          MANPAGER env to use for `man` preview.
        '';
      };

      jump = {
        jumplist = defaultNullOpts.mkBool true ''
          Save the current position in the jumplist.
        '';

        tagstack = defaultNullOpts.mkBool false ''
          Save the current position in the tagstack.
        '';

        reuse_win = defaultNullOpts.mkBool false ''
          Reuse an existing window if the buffer is already open.
        '';

        close = defaultNullOpts.mkBool true ''
          Close the picker when jumping/editing to a location.
        '';

        match = defaultNullOpts.mkBool false ''
          Jump to the first match position.
        '';
      };

      toggles =
        defaultNullOpts.mkAttrsOf (types.either types.str types.bool)
          {
            follow = "f";
            hidden = "h";
            ignored = "i";
            modified = "m";
            regex = {
              icon = "R";
              value = false;
            };
          }
          ''
            Toggle mappings.
          '';

      win = {
        input =
          defaultNullOpts.mkAttrsOf types.anything
            {
              keys = {
                "/" = "toggle_focus";
                "<C-Down>" = {
                  __unkeyed-1 = "history_forward";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<C-Up>" = {
                  __unkeyed-1 = "history_back";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<C-c>" = {
                  __unkeyed-1 = "cancel";
                  mode = "i";
                };
                "<C-w>" = {
                  __unkeyed-1 = "<c-s-w>";
                  mode = [ "i" ];
                  expr = true;
                  desc = "delete word";
                };
                "<CR>" = {
                  __unkeyed-1 = "confirm";
                  mode = [
                    "n"
                    "i"
                  ];
                };
                "<Down>" = {
                  __unkeyed-1 = "list_down";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<Esc>" = "cancel";
                "<S-CR>" = {
                  __unkeyed-1 = [
                    "pick_win"
                    "jump"
                  ];
                  mode = [
                    "n"
                    "i"
                  ];
                };
                "<S-Tab>" = {
                  __unkeyed-1 = "select_and_prev";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<Tab>" = {
                  __unkeyed-1 = "select_and_next";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<Up>" = {
                  __unkeyed-1 = "list_up";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<a-d>" = {
                  __unkeyed-1 = "inspect";
                  mode = [
                    "n"
                    "i"
                  ];
                };
                "<a-f>" = {
                  __unkeyed-1 = "toggle_follow";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<a-h>" = {
                  __unkeyed-1 = "toggle_hidden";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<a-i>" = {
                  __unkeyed-1 = "toggle_ignored";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<a-m>" = {
                  __unkeyed-1 = "toggle_maximize";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<a-p>" = {
                  __unkeyed-1 = "toggle_preview";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<a-w>" = {
                  __unkeyed-1 = "cycle_win";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<c-a>" = {
                  __unkeyed-1 = "select_all";
                  mode = [
                    "n"
                    "i"
                  ];
                };
                "<c-b>" = {
                  __unkeyed-1 = "preview_scroll_up";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<c-d>" = {
                  __unkeyed-1 = "list_scroll_down";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<c-f>" = {
                  __unkeyed-1 = "preview_scroll_down";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<c-g>" = {
                  __unkeyed-1 = "toggle_live";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<c-j>" = {
                  __unkeyed-1 = "list_down";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<c-k>" = {
                  __unkeyed-1 = "list_up";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<c-n>" = {
                  __unkeyed-1 = "list_down";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<c-p>" = {
                  __unkeyed-1 = "list_up";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<c-q>" = {
                  __unkeyed-1 = "qflist";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<c-s>" = {
                  __unkeyed-1 = "edit_split";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<c-t>" = {
                  __unkeyed-1 = "tab";
                  mode = [
                    "n"
                    "i"
                  ];
                };
                "<c-u>" = {
                  __unkeyed-1 = "list_scroll_up";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<c-v>" = {
                  __unkeyed-1 = "edit_vsplit";
                  mode = [
                    "i"
                    "n"
                  ];
                };
                "<c-r>#" = {
                  __unkeyed-1 = "insert_alt";
                  mode = "i";
                };
                "<c-r>%" = {
                  __unkeyed-1 = "insert_filename";
                  mode = "i";
                };
                "<c-r><c-a>" = {
                  __unkeyed-1 = "insert_cWORD";
                  mode = "i";
                };
                "<c-r><c-f>" = {
                  __unkeyed-1 = "insert_file";
                  mode = "i";
                };
                "<c-r><c-l>" = {
                  __unkeyed-1 = "insert_line";
                  mode = "i";
                };
                "<c-r><c-p>" = {
                  __unkeyed-1 = "insert_file_full";
                  mode = "i";
                };
                "<c-r><c-w>" = {
                  __unkeyed-1 = "insert_cword";
                  mode = "i";
                };
                "<c-w>H" = "layout_left";
                "<c-w>J" = "layout_bottom";
                "<c-w>K" = "layout_top";
                "<c-w>L" = "layout_right";
                "?" = "toggle_help_input";
                "G" = "list_bottom";
                "gg" = "list_top";
                "j" = "list_down";
                "k" = "list_up";
                "q" = "close";
              };
              b = {
                minipairs_disable = true;
              };
            }
            ''
              Input window configuration.
            '';

        list =
          defaultNullOpts.mkAttrsOf types.anything
            {
              keys = {
                "/" = "toggle_focus";
                "<2-LeftMouse>" = "confirm";
                "<CR>" = "confirm";
                "<Down>" = "list_down";
                "<Esc>" = "cancel";
                "<S-CR>" = {
                  __unkeyed-1 = [
                    "pick_win"
                    "jump"
                  ];
                };
                "<S-Tab>" = {
                  __unkeyed-1 = "select_and_prev";
                  mode = [
                    "n"
                    "x"
                  ];
                };
                "<Tab>" = {
                  __unkeyed-1 = "select_and_next";
                  mode = [
                    "n"
                    "x"
                  ];
                };
                "<Up>" = "list_up";
                "<a-d>" = "inspect";
                "<a-f>" = "toggle_follow";
                "<a-h>" = "toggle_hidden";
                "<a-i>" = "toggle_ignored";
                "<a-m>" = "toggle_maximize";
                "<a-p>" = "toggle_preview";
                "<a-w>" = "cycle_win";
                "<c-a>" = "select_all";
                "<c-b>" = "preview_scroll_up";
                "<c-d>" = "list_scroll_down";
                "<c-f>" = "preview_scroll_down";
                "<c-j>" = "list_down";
                "<c-k>" = "list_up";
                "<c-n>" = "list_down";
                "<c-p>" = "list_up";
                "<c-q>" = "qflist";
                "<c-s>" = "edit_split";
                "<c-t>" = "tab";
                "<c-u>" = "list_scroll_up";
                "<c-v>" = "edit_vsplit";
                "<c-w>H" = "layout_left";
                "<c-w>J" = "layout_bottom";
                "<c-w>K" = "layout_top";
                "<c-w>L" = "layout_right";
                "?" = "toggle_help_list";
                "G" = "list_bottom";
                "gg" = "list_top";
                "i" = "focus_input";
                "j" = "list_down";
                "k" = "list_up";
                "q" = "close";
                "zb" = "list_scroll_bottom";
                "zt" = "list_scroll_top";
                "zz" = "list_scroll_center";
              };
              wo = {
                conceallevel = 2;
                concealcursor = "nvc";
              };
            }
            ''
              Result list window configuration.
            '';

        preview =
          defaultNullOpts.mkAttrsOf types.anything
            {
              keys = {
                "<Esc>" = "cancel";
                "q" = "close";
                "i" = "focus_input";
                "<a-w>" = "cycle_win";
              };
            }
            ''
              Preview window configuration.
            '';
      };

      icons = {
        files = {
          enabled = defaultNullOpts.mkBool true ''
            Show file icons.
          '';

          dir = defaultNullOpts.mkStr "󰉋 " ''
            Directory icon.
          '';

          dir_open = defaultNullOpts.mkStr "󰝰 " ''
            Open directory icon.
          '';

          file = defaultNullOpts.mkStr "󰈔 " ''
            File icon.
          '';
        };

        keymaps = {
          nowait = defaultNullOpts.mkStr "󰓅 " ''
            Nowait icon.
          '';
        };

        tree = {
          vertical = defaultNullOpts.mkStr "│ " ''
            Vertical tree line.
          '';

          middle = defaultNullOpts.mkStr "├╴" ''
            Middle tree branch.
          '';

          last = defaultNullOpts.mkStr "└╴" ''
            Last tree branch.
          '';
        };

        undo = {
          saved = defaultNullOpts.mkStr " " ''
            Saved undo icon.
          '';
        };

        ui = {
          live = defaultNullOpts.mkStr "󰐰 " ''
            Live search icon.
          '';

          hidden = defaultNullOpts.mkStr "h" ''
            Hidden files icon.
          '';

          ignored = defaultNullOpts.mkStr "i" ''
            Ignored files icon.
          '';

          follow = defaultNullOpts.mkStr "f" ''
            Follow symlinks icon.
          '';

          selected = defaultNullOpts.mkStr "● " ''
            Selected item icon.
          '';

          unselected = defaultNullOpts.mkStr "○ " ''
            Unselected item icon.
          '';
        };

        git = {
          enabled = defaultNullOpts.mkBool true ''
            Show git icons.
          '';

          commit = defaultNullOpts.mkStr "󰜘 " ''
            Git commit icon.
          '';

          staged = defaultNullOpts.mkStr "●" ''
            Staged changes icon.
          '';

          added = defaultNullOpts.mkStr "" ''
            Added file icon.
          '';

          deleted = defaultNullOpts.mkStr "" ''
            Deleted file icon.
          '';

          ignored = defaultNullOpts.mkStr " " ''
            Ignored file icon.
          '';

          modified = defaultNullOpts.mkStr "○" ''
            Modified file icon.
          '';

          renamed = defaultNullOpts.mkStr "" ''
            Renamed file icon.
          '';

          unmerged = defaultNullOpts.mkStr " " ''
            Unmerged file icon.
          '';

          untracked = defaultNullOpts.mkStr "?" ''
            Untracked file icon.
          '';
        };

        diagnostics = {
          Error = defaultNullOpts.mkStr " " ''
            Error icon.
          '';

          Warn = defaultNullOpts.mkStr " " ''
            Warning icon.
          '';

          Hint = defaultNullOpts.mkStr " " ''
            Hint icon.
          '';

          Info = defaultNullOpts.mkStr " " ''
            Info icon.
          '';
        };

        lsp = {
          unavailable = defaultNullOpts.mkStr "" ''
            LSP unavailable icon.
          '';

          enabled = defaultNullOpts.mkStr " " ''
            LSP enabled icon.
          '';

          disabled = defaultNullOpts.mkStr " " ''
            LSP disabled icon.
          '';

          attached = defaultNullOpts.mkStr "󰖩 " ''
            LSP attached icon.
          '';
        };

        kinds =
          defaultNullOpts.mkAttrsOf types.str
            {
              Array = " ";
              Boolean = "󰨙 ";
              Class = " ";
              Color = " ";
              Control = " ";
              Collapsed = " ";
              Constant = "󰏿 ";
              Constructor = " ";
              Copilot = " ";
              Enum = " ";
              EnumMember = " ";
              Event = " ";
              Field = " ";
              File = " ";
              Folder = " ";
              Function = "󰊕 ";
              Interface = " ";
              Key = " ";
              Keyword = " ";
              Method = "󰊕 ";
              Module = " ";
              Namespace = "󰦮 ";
              Null = " ";
              Number = "󰎠 ";
              Object = " ";
              Operator = " ";
              Package = " ";
              Property = " ";
              Reference = " ";
              Snippet = "󱄽 ";
              String = " ";
              Struct = "󰆼 ";
              Text = " ";
              TypeParameter = " ";
              Unit = " ";
              Unknown = " ";
              Value = " ";
              Variable = "󰀫 ";
            }
            ''
              LSP kind icons.
            '';
      };

      db = {
        sqlite3_path = defaultNullOpts.mkStr null ''
          Path to the sqlite3 library.
          If not set, it will try to load the library by name.
        '';
      };

      debug = {
        scores = defaultNullOpts.mkBool false ''
          Show scores in the list.
        '';

        leaks = defaultNullOpts.mkBool false ''
          Show when pickers don't get garbage collected.
        '';

        explorer = defaultNullOpts.mkBool false ''
          Show explorer debug info.
        '';

        files = defaultNullOpts.mkBool false ''
          Show file debug info.
        '';

        grep = defaultNullOpts.mkBool false ''
          Show grep debug info.
        '';

        proc = defaultNullOpts.mkBool false ''
          Show proc debug info.
        '';

        extmarks = defaultNullOpts.mkBool false ''
          Show extmarks errors.
        '';
      };
    };

    profiler = {
      enabled = defaultNullOpts.mkBool false ''
        Whether to enable the Lua profiler.
        A low overhead profiler for Neovim with instrumentation, autocmd profiling,
        and support for viewing traces with different pickers.
      '';

      autocmds = defaultNullOpts.mkBool true ''
        Enable profiling of autocmds.
      '';

      runtime = defaultNullOpts.mkStr { __raw = "vim.env.VIMRUNTIME"; } ''
        Path to Neovim runtime for filtering.
      '';

      thresholds = {
        time = defaultNullOpts.mkListOf types.int [ 2 10 ] ''
          Thresholds for time badges to be shown as warn or error.
          Format: [warn, error] in milliseconds.
        '';

        pct = defaultNullOpts.mkListOf types.int [ 10 20 ] ''
          Thresholds for percentage badges to be shown as warn or error.
          Format: [warn, error] in percentage.
        '';

        count = defaultNullOpts.mkListOf types.int [ 10 100 ] ''
          Thresholds for count badges to be shown as warn or error.
          Format: [warn, error] in count.
        '';
      };

      on_stop = {
        highlights = defaultNullOpts.mkBool true ''
          Highlight entries after stopping the profiler.
        '';

        pick = defaultNullOpts.mkBool true ''
          Show a picker after stopping the profiler (uses the `on_stop` preset).
        '';
      };

      highlights = {
        min_time = defaultNullOpts.mkNum 0 ''
          Only highlight entries with time > min_time (in ms).
        '';

        max_shade = defaultNullOpts.mkNum 20 ''
          Time in ms for the darkest shade.
        '';

        badges = defaultNullOpts.mkListOf types.str [ "time" "pct" "count" "trace" ] ''
          Badges to show in highlights.
        '';

        align = defaultNullOpts.mkNum 80 ''
          Align the badges at a specific column.
        '';
      };

      pick = {
        picker = defaultNullOpts.mkEnumFirstDefault [ "snacks" "trouble" ] ''
          Picker to use for showing traces.
        '';

        badges = defaultNullOpts.mkListOf types.str [ "time" "count" "name" ] ''
          Badges to show in the picker.
        '';

        preview = {
          badges = defaultNullOpts.mkListOf types.str [ "time" "pct" "count" ] ''
            Badges to show in the preview.
          '';

          align = defaultNullOpts.mkEnumFirstDefault [ "right" "left" ] ''
            Alignment for preview badges.
          '';
        };
      };

      startup = {
        event = defaultNullOpts.mkStr "VimEnter" ''
          Stop profiler on this event when using startup profiling.
        '';

        after = defaultNullOpts.mkBool true ''
          Stop the profiler after the event. When false it stops at the event.
        '';

        pattern = defaultNullOpts.mkStr null ''
          Pattern to match for the autocmd.
        '';

        pick = defaultNullOpts.mkBool true ''
          Show a picker after starting the profiler (uses the `startup` preset).
        '';
      };

      presets =
        defaultNullOpts.mkAttrsOf types.anything
          {
            startup = {
              min_time = 1;
              sort = false;
            };
            on_stop = { };
            filter_by_plugin = {
              __raw = ''
                function()
                  return { filter = { def_plugin = vim.fn.input("Filter by plugin: ") } }
                end
              '';
            };
          }
          ''
            Preset configurations for different profiling scenarios.
          '';

      globals = defaultNullOpts.mkListOf types.str [ ] ''
        List of global tables/functions to profile.
        Example: ["vim", "vim.api", "vim.keymap"]
      '';

      filter_mod =
        defaultNullOpts.mkAttrsOf types.bool
          {
            default = true;
            "^vim%." = false;
            "mason-core.functional" = false;
            "mason-core.functional.data" = false;
            "mason-core.optional" = false;
            "which-key.state" = false;
          }
          ''
            Filter modules by pattern. Longest patterns are matched first.
          '';

      filter_fn =
        defaultNullOpts.mkAttrsOf types.bool
          {
            default = true;
            "^.*%._[^%.]*$" = false;
            "trouble.filter.is" = false;
            "trouble.item.__index" = false;
            "which-key.node.__index" = false;
            "smear_cursor.draw.wo" = false;
            "^ibl%.utils%." = false;
          }
          ''
            Filter functions by pattern.
          '';

      icons = {
        time = defaultNullOpts.mkStr " " "Icon for time";
        pct = defaultNullOpts.mkStr " " "Icon for percentage";
        count = defaultNullOpts.mkStr " " "Icon for count";
        require = defaultNullOpts.mkStr "󰋺 " "Icon for require";
        modname = defaultNullOpts.mkStr "󰆼 " "Icon for module name";
        plugin = defaultNullOpts.mkStr " " "Icon for plugin";
        autocmd = defaultNullOpts.mkStr "⚡" "Icon for autocmd";
        file = defaultNullOpts.mkStr " " "Icon for file";
        fn = defaultNullOpts.mkStr "󰊕 " "Icon for function";
        status = defaultNullOpts.mkStr "󰈸 " "Icon for status";
      };

      debug = defaultNullOpts.mkBool false ''
        Enable debug mode for the profiler.
      '';
    };

    quickfile = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable `quickfile` plugin.
      '';

      exclude = defaultNullOpts.mkListOf types.str [ "latex" ] ''
        Filetypes to exclude from `quickfile` plugin.
      '';
    };

    rename = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable the rename plugin.
        Provides LSP-integrated file renaming with support for plugins like neo-tree.nvim and mini.files.
      '';
    };

    scope = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable scope detection, text objects and jumping based on treesitter or indent.
      '';

      min_size = defaultNullOpts.mkNum 2 ''
        Absolute minimum size of the scope. Can be less if the scope is a top-level single line scope.
      '';

      max_size = defaultNullOpts.mkNum null ''
        Try to expand the scope to this size. nil means no limit.
      '';

      cursor = defaultNullOpts.mkBool true ''
        When true, the column of the cursor is used to determine the scope.
      '';

      edge = defaultNullOpts.mkBool true ''
        Include the edge of the scope (typically the line above and below with smaller indent).
      '';

      siblings = defaultNullOpts.mkBool false ''
        Expand single line scopes with single line siblings.
      '';

      filter =
        defaultNullOpts.mkRaw
          ''
            function(buf)
              return vim.bo[buf].buftype == "" and vim.b[buf].snacks_scope ~= false and vim.g.snacks_scope ~= false
            end
          ''
          ''
            Filter function to determine which buffers to attach scope detection to.
            By default, only attaches to normal buffers and respects toggle variables.
          '';

      debounce = defaultNullOpts.mkNum 30 ''
        Debounce scope detection in milliseconds.
      '';

      treesitter = {
        enabled = defaultNullOpts.mkBool true ''
          Detect scope based on treesitter. Falls back to indent-based detection if not available.
        '';

        injections = defaultNullOpts.mkBool true ''
          Include language injections when detecting scope (useful for languages like vue).
        '';

        blocks =
          defaultNullOpts.mkAttrsOf types.anything
            {
              enabled = false;
              __unkeyed = [
                "function_declaration"
                "function_definition"
                "method_declaration"
                "method_definition"
                "class_declaration"
                "class_definition"
                "do_statement"
                "while_statement"
                "repeat_statement"
                "if_statement"
                "for_statement"
              ];
            }
            ''
              Treesitter node types to consider as blocks.
              Set enabled=true to use the default block types.
            '';

        field_blocks = defaultNullOpts.mkListOf types.str [ "local_declaration" ] ''
          Treesitter fields that will be considered as blocks.
        '';
      };

      keys = {
        textobject =
          defaultNullOpts.mkAttrsOf types.anything
            {
              ii = {
                min_size = 2;
                edge = false;
                cursor = false;
                treesitter = {
                  blocks = {
                    enabled = false;
                  };
                };
                desc = "inner scope";
              };
              ai = {
                cursor = false;
                min_size = 2;
                treesitter = {
                  blocks = {
                    enabled = false;
                  };
                };
                desc = "full scope";
              };
            }
            ''
              Text object keymaps. Keys are the keymap, values are TextObject options.
            '';

        jump =
          defaultNullOpts.mkAttrsOf types.anything
            {
              "[i" = {
                min_size = 1;
                bottom = false;
                cursor = false;
                edge = true;
                treesitter = {
                  blocks = {
                    enabled = false;
                  };
                };
                desc = "jump to top edge of scope";
              };
              "]i" = {
                min_size = 1;
                bottom = true;
                cursor = false;
                edge = true;
                treesitter = {
                  blocks = {
                    enabled = false;
                  };
                };
                desc = "jump to bottom edge of scope";
              };
            }
            ''
              Jump keymaps. Keys are the keymap, values are Jump options.
            '';
      };
    };

    scratch = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable scratch buffers with persistent files.
      '';

      name = defaultNullOpts.mkStr "Scratch" ''
        Name for the scratch buffer.
      '';

      ft =
        defaultNullOpts.mkRaw
          ''
            function()
              if vim.bo.buftype == "" and vim.bo.filetype ~= "" then
                return vim.bo.filetype
              end
              return "markdown"
            end
          ''
          ''
            The filetype of the scratch buffer. Can be a string or function.
          '';

      icon = defaultNullOpts.mkStrLuaOr (types.listOf types.str) null ''
        Icon for the scratch buffer. Can be a string or {icon, icon_hl}.
        Defaults to the filetype icon.
      '';

      root = defaultNullOpts.mkRaw ''vim.fn.stdpath("data") .. "/scratch"'' ''
        Root directory for scratch files.
      '';

      autowrite = defaultNullOpts.mkBool true ''
        Automatically write when the buffer is hidden.
      '';

      filekey = {
        cwd = defaultNullOpts.mkBool true ''
          Use current working directory in the unique key.
        '';

        branch = defaultNullOpts.mkBool true ''
          Use current Git branch name in the unique key.
        '';

        count = defaultNullOpts.mkBool true ''
          Use vim.v.count1 in the unique key.
        '';
      };

      win = defaultNullOpts.mkAttrsOf types.anything { style = "scratch"; } ''
        Window configuration for scratch buffers.
      '';

      win_by_ft =
        defaultNullOpts.mkAttrsOf types.anything
          {
            lua = {
              keys = {
                source = {
                  __unkeyed-1 = "<cr>";
                  __unkeyed-2.__raw = ''
                    function(self)
                      local name = "scratch." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
                      Snacks.debug.run({ buf = self.buf, name = name })
                    end
                  '';
                  desc = "Source buffer";
                  mode = [
                    "n"
                    "x"
                  ];
                };
              };
            };
          }
          ''
            Window configuration per filetype.
          '';

      template = defaultNullOpts.mkStr null ''
        Template for new buffers.
      '';

      file = defaultNullOpts.mkStr null ''
        Scratch file path. You probably don't need to set this.
      '';
    };

    scroll = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable smooth scrolling.
        Properly handles scrolloff and mouse scrolling.
      '';

      animate = {
        duration = {
          step = defaultNullOpts.mkNum 15 ''
            Duration of each animation step in milliseconds.
          '';

          total = defaultNullOpts.mkNum 250 ''
            Total duration of the scroll animation in milliseconds.
          '';
        };

        easing = defaultNullOpts.mkStr "linear" ''
          Easing function for the scroll animation.
          Can be "linear" or any other easing function provided by the animate module.
        '';
      };

      animate_repeat = {
        delay = defaultNullOpts.mkNum 100 ''
          Delay in milliseconds before using the repeat animation when continuously scrolling.
        '';

        duration = {
          step = defaultNullOpts.mkNum 5 ''
            Duration of each animation step for repeated scrolls in milliseconds.
          '';

          total = defaultNullOpts.mkNum 50 ''
            Total duration of the repeat scroll animation in milliseconds.
          '';
        };

        easing = defaultNullOpts.mkStr "linear" ''
          Easing function for repeated scroll animations.
        '';
      };

      filter =
        defaultNullOpts.mkRaw
          ''
            function(buf)
              return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and vim.bo[buf].buftype ~= "terminal"
            end
          ''
          ''
            Filter function to determine which buffers should have smooth scrolling.
            By default, excludes terminal buffers and respects global/buffer-local toggle variables.
          '';

      debug = defaultNullOpts.mkBool false ''
        Enable debug mode for scroll animations.
      '';
    };

    statuscolumn = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable `statuscolumn` plugin.
      '';

      left =
        defaultNullOpts.mkListOf types.str
          [
            "mark"
            "sign"
          ]
          ''
            Priority of signs on the left (high to low).
          '';

      right =
        defaultNullOpts.mkListOf types.str
          [
            "fold"
            "git"
          ]
          ''
            Priority of signs on the right (high to low)
          '';
      folds = {
        open = defaultNullOpts.mkBool false ''
          Whether to show open fold icons.
        '';

        git_hl = defaultNullOpts.mkBool false ''
          Whether to use Git Signs hl for fold icons.
        '';
      };
      git = {
        patterns =
          defaultNullOpts.mkListOf types.str
            [
              "GitSign"
              "MiniDiffSign"
            ]
            ''
              Patterns to match Git signs.
            '';
      };

      refresh = defaultNullOpts.mkUnsignedInt 50 ''
        Time in milliseconds to refresh statuscolumn.
      '';
    };

    terminal = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable the terminal plugin.
        Create and toggle floating or split terminal windows.
      '';

      win = defaultNullOpts.mkAttrsOf types.anything { style = "terminal"; } ''
        Window configuration for terminal windows.
        By default uses the "terminal" style which includes special keybindings.
      '';

      shell = defaultNullOpts.mkAttrsOf types.anything null ''
        The shell to use for terminals.
        Can be a string or array of strings.
        Defaults to vim.o.shell if not specified.
      '';

      override = defaultNullOpts.mkRaw null ''
        Function to override terminal implementation.
        Use this to integrate with other terminal plugins.
        Function signature: fun(cmd?: string|string[], opts?: snacks.terminal.Opts)
      '';
    };

    toggle = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable toggle keymaps integrated with which-key icons/colors.
      '';

      map = defaultNullOpts.mkRaw "vim.keymap.set" ''
        Keymap.set function to use for creating toggle keymaps.
      '';

      which_key = defaultNullOpts.mkBool true ''
        Integrate with which-key to show enabled/disabled icons and colors.
      '';

      notify = defaultNullOpts.mkBool true ''
        Show a notification when toggling.
      '';

      icon =
        defaultNullOpts.mkAttrsOf types.str
          {
            enabled = " ";
            disabled = " ";
          }
          ''
            Icons for enabled/disabled states.
          '';

      color =
        defaultNullOpts.mkAttrsOf types.str
          {
            enabled = "green";
            disabled = "yellow";
          }
          ''
            Colors for enabled/disabled states.
          '';

      wk_desc =
        defaultNullOpts.mkAttrsOf types.str
          {
            enabled = "Disable ";
            disabled = "Enable ";
          }
          ''
            Which-key description prefixes for enabled/disabled states.
          '';
    };

    util = {
      enabled = defaultNullOpts.mkBool true ''
        Enable utility functions for Snacks.
        This is a library module that provides various utility functions used by other Snacks plugins.
        Functions include color manipulation, debouncing, icon handling, treesitter utilities, and more.
        The util module doesn't have configuration options - it's a collection of utility functions.
      '';
    };

    win = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable the window management library.
        Easily create and manage floating windows or splits.
      '';

      style = defaultNullOpts.mkStr null ''
        Style to merge with config from Snacks.config.styles[style].
      '';

      show = defaultNullOpts.mkBool true ''
        Show the window immediately.
      '';

      height = defaultNullOpts.mkAttrsOf types.anything 0.9 ''
        Height of the window. Use <1 for relative height. 0 means full height.
        Can be a number or a function returning a number.
      '';

      width = defaultNullOpts.mkAttrsOf types.anything 0.9 ''
        Width of the window. Use <1 for relative width. 0 means full width.
        Can be a number or a function returning a number.
      '';

      min_height = defaultNullOpts.mkNum null ''
        Minimum height of the window.
      '';

      max_height = defaultNullOpts.mkNum null ''
        Maximum height of the window.
      '';

      min_width = defaultNullOpts.mkNum null ''
        Minimum width of the window.
      '';

      max_width = defaultNullOpts.mkNum null ''
        Maximum width of the window.
      '';

      col = defaultNullOpts.mkAttrsOf types.anything null ''
        Column of the window. Use <1 for relative column. Default: center.
        Can be a number or a function returning a number.
      '';

      row = defaultNullOpts.mkAttrsOf types.anything null ''
        Row of the window. Use <1 for relative row. Default: center.
        Can be a number or a function returning a number.
      '';

      minimal = defaultNullOpts.mkBool true ''
        Disable a bunch of options to make the window minimal.
      '';

      position = defaultNullOpts.mkEnumFirstDefault [ "float" "bottom" "top" "left" "right" ] ''
        Window position.
      '';

      border = defaultNullOpts.mkAttrsOf types.anything null ''
        Border style. Can be "none", "top", "right", "bottom", "left", "hpad", "vpad",
        "rounded", "single", "double", "solid", "shadow", a list of strings, or false.
      '';

      buf = defaultNullOpts.mkNum null ''
        If set, use this buffer instead of creating a new one.
      '';

      file = defaultNullOpts.mkStr null ''
        If set, use this file instead of creating a new buffer.
      '';

      enter = defaultNullOpts.mkBool false ''
        Enter the window after opening.
      '';

      backdrop = defaultNullOpts.mkAttrsOf types.anything 60 ''
        Opacity of the backdrop (0-100), false to disable, or a backdrop configuration table.
      '';

      wo =
        defaultNullOpts.mkAttrsOf types.anything
          {
            winhighlight = "Normal:SnacksNormal,NormalNC:SnacksNormalNC,WinBar:SnacksWinBar,WinBarNC:SnacksWinBarNC";
          }
          ''
            Window options to set on the window.
          '';

      bo = defaultNullOpts.mkAttrsOf types.anything { } ''
        Buffer options to set on the buffer.
      '';

      b = defaultNullOpts.mkAttrsOf types.anything null ''
        Buffer local variables to set.
      '';

      w = defaultNullOpts.mkAttrsOf types.anything null ''
        Window local variables to set.
      '';

      ft = defaultNullOpts.mkStr null ''
        Filetype to use for treesitter/syntax highlighting. Won't override existing filetype.
      '';

      scratch_ft = defaultNullOpts.mkStr null ''
        Filetype to use for scratch buffers.
      '';

      keys =
        defaultNullOpts.mkAttrsOf types.anything
          {
            q = "close";
          }
          ''
            Key mappings. Keys can be mapped to false, a string action, a function, or a table.
          '';

      on_buf = defaultNullOpts.mkRaw null ''
        Callback after opening the buffer.
        Function signature: fun(self: snacks.win)
      '';

      on_win = defaultNullOpts.mkRaw null ''
        Callback after opening the window.
        Function signature: fun(self: snacks.win)
      '';

      on_close = defaultNullOpts.mkRaw null ''
        Callback after closing the window.
        Function signature: fun(self: snacks.win)
      '';

      fixbuf = defaultNullOpts.mkBool true ''
        Don't allow other buffers to be opened in this window.
      '';

      text = defaultNullOpts.mkAttrsOf types.anything null ''
        Initial lines to set in the buffer.
        Can be a string, string array, or function returning strings.
      '';

      actions = defaultNullOpts.mkAttrsOf types.anything null ''
        Actions that can be used in key mappings.
      '';

      resize = defaultNullOpts.mkBool false ''
        Automatically resize the window when the editor is resized.
      '';

      relative = defaultNullOpts.mkStr "editor" ''
        What the window is relative to. See :h nvim_open_win().
      '';
    };

    words = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable `words` plugin.
      '';

      debounce = defaultNullOpts.mkUnsignedInt 200 ''
        Time in ms to wait before updating.
      '';

      notify_jump = defaultNullOpts.mkBool false ''
        Whether to show a notification when jumping.
      '';

      notify_end = defaultNullOpts.mkBool true ''
        Whether to show a notification when reaching the end.
      '';

      foldopen = defaultNullOpts.mkBool true ''
        Whether to open folds after jumping.
      '';

      jumplist = defaultNullOpts.mkBool true ''
        Whether to set jump point before jumping.
      '';

      modes =
        defaultNullOpts.mkListOf types.str
          [
            "n"
            "i"
            "c"
          ]
          ''
            Modes to show references.
          '';
    };

    zen = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable zen mode for distraction-free coding.
        Integrates with Snacks.toggle to toggle various UI elements and with Snacks.dim to dim code out of scope.
      '';

      toggles =
        defaultNullOpts.mkAttrsOf types.bool
          {
            dim = true;
            git_signs = false;
            mini_diff_signs = false;
          }
          ''
            Table of Snacks.toggle ids to enable/disable in zen mode.
            Toggle state is restored when the window is closed.
            Toggle config options are NOT merged.
          '';

      show =
        defaultNullOpts.mkAttrsOf types.bool
          {
            statusline = false;
            tabline = false;
          }
          ''
            UI elements to show in zen mode.
            statusline can only be shown when using the global statusline.
          '';

      win = defaultNullOpts.mkAttrsOf types.anything { style = "zen"; } ''
        Window configuration for zen mode.
        Uses the "zen" window style by default.
      '';

      on_open = defaultNullOpts.mkRaw "function(win) end" ''
        Callback when the zen window is opened.
      '';

      on_close = defaultNullOpts.mkRaw "function(win) end" ''
        Callback when the zen window is closed.
      '';

      zoom =
        defaultNullOpts.mkAttrsOf types.anything
          {
            toggles = { };
            show = {
              statusline = true;
              tabline = true;
            };
            win = {
              backdrop = false;
              width = 0;
            };
          }
          ''
            Options for Snacks.zen.zoom() function.
            Zoom provides a full-width window mode.
          '';
    };
  };

  settingsExample = {
    animate = {
      enabled = true;
      duration = {
        step = 20;
        total = 500;
      };
      easing = "inOutCubic";
      fps = 60;
    };
    bigfile = {
      enabled = true;
    };
    bufdelete = {
      enabled = true;
    };
    dashboard = {
      enabled = true;
    };
    debug = {
      enabled = true;
    };
    dim = {
      enabled = true;
      scope = {
        min_size = 5;
        max_size = 20;
      };
    };
    explorer = {
      enabled = true;
      replace_netrw = true;
    };
    git = {
      enabled = true;
    };
    gitbrowse = {
      enabled = true;
      what = "commit";
      notify = true;
    };
    image = {
      enabled = true;
      force = false;
      doc = {
        enabled = true;
        inline = true;
        float = true;
      };
    };
    indent = {
      enabled = true;
      scope = {
        enabled = true;
      };
    };
    input = {
      enabled = true;
      prompt_pos = "title";
      icon_pos = "left";
    };
    layout = {
      enabled = true;
      layout = {
        box = "horizontal";
        width = 0.8;
        height = 0.8;
        __unkeyed-1 = {
          win = "left";
          width = 0.3;
        };
        __unkeyed-2 = {
          win = "right";
          width = 0.7;
        };
      };
    };
    lazygit = {
      enabled = true;
      configure = true;
      win = {
        width = 0.9;
        height = 0.9;
      };
    };
    notifier = {
      enabled = true;
      timeout = 3000;
    };
    notify = {
      enabled = true;
    };
    picker = {
      enabled = true;
      ui_select = true;
      matcher = {
        fuzzy = true;
        smartcase = true;
      };
      formatters = {
        file = {
          filename_first = false;
          truncate = 40;
        };
      };
    };
    profiler = {
      enabled = true;
      on_stop = {
        highlights = true;
        pick = true;
      };
      pick = {
        picker = "snacks";
      };
    };
    quickfile = {
      enabled = false;
    };
    rename = {
      enabled = true;
    };
    scope = {
      enabled = true;
      treesitter = {
        enabled = true;
        blocks = {
          enabled = true;
        };
      };
    };
    scratch = {
      enabled = true;
      name = "Scratch";
      autowrite = true;
      filekey = {
        cwd = true;
        branch = true;
        count = true;
      };
    };
    scroll = {
      enabled = true;
      animate = {
        duration = {
          step = 15;
          total = 250;
        };
      };
    };
    statuscolumn = {
      enabled = false;
    };
    terminal = {
      enabled = true;
      win = {
        position = "bottom";
        height = 0.3;
      };
    };
    toggle = {
      enabled = true;
      notify = true;
      which_key = true;
    };
    util = {
      enabled = true;
    };
    win = {
      enabled = true;
      position = "float";
      backdrop = 60;
      border = "rounded";
      wo = {
        wrap = false;
        linebreak = true;
      };
    };
    words = {
      enabled = true;
      debounce = 100;
    };
    zen = {
      enabled = true;
      toggles = {
        dim = true;
        diagnostics = false;
      };
      win = {
        width = 120;
      };
    };
  };
}
