{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.lean;
in
{
  options.plugins.lean = lib.nixvim.plugins.neovim.extraOptionsOptions // {
    enable = mkEnableOption "lean-nvim";

    package = lib.mkPackageOption pkgs "lean-nvim" {
      default = [
        "vimPlugins"
        "lean-nvim"
      ];
    };

    leanPackage = lib.mkPackageOption pkgs "lean" {
      nullable = true;
      default = "lean4";
    };

    lsp = helpers.defaultNullOpts.mkNullable (
      with types;
      submodule {
        freeformType = types.attrs;
        options = {
          enable = helpers.defaultNullOpts.mkBool true ''
            Whether to enable the Lean language server(s) ?

            Set to `false` to disable, otherwise should be a table of options to pass to
            `leanls`.
            See https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#leanls
            for details.
          '';

          on_attach = helpers.mkNullOrOption types.str ''
            The LSP handler.
          '';

          init_options = helpers.mkNullOrOption (with types; attrsOf anything) ''
            The options to configure the lean language server.
            See `Lean.Lsp.InitializationOptions` for details.
          '';
        };
      }
    ) { } "LSP settings.";

    ft = {
      default = helpers.defaultNullOpts.mkStr "lean" ''
        The default filetype for Lean files.
      '';

      nomodifiable = helpers.mkNullOrOption (with types; listOf str) ''
        A list of patterns which will be used to protect any matching Lean file paths from being
        accidentally modified (by marking the buffer as `nomodifiable`).

        By default, this list includes the Lean standard libraries, as well as files within
        dependency directories (e.g. `_target`)
        Set this to an empty table to disable.
      '';
    };

    abbreviations = {
      enable = helpers.defaultNullOpts.mkBool true ''
        Whether to enable expanding of unicode abbreviations.
      '';

      extra = helpers.defaultNullOpts.mkAttrsOf types.str { } ''
        Additional abbreviations.

        Example:
        ```
          {
            # Add a \wknight abbreviation to insert ♘
            #
            # Note that the backslash is implied, and that you of
            # course may also use a snippet engine directly to do
            # this if so desired.
            wknight = "♘";
          }
      '';

      leader = helpers.defaultNullOpts.mkStr "\\" ''
        Change if you don't like the backslash.
        (comma is a popular choice on French keyboards)
      '';
    };

    mappings = helpers.defaultNullOpts.mkBool false ''
      Whether to enable suggested mappings.
    '';

    infoview = {
      autoopen = helpers.defaultNullOpts.mkBool true ''
        Automatically open an infoview on entering a Lean buffer?
        Should be a function that will be called anytime a new Lean file is opened.
        Return true to open an infoview, otherwise false.
        Setting this to `true` is the same as `function() return true end`, i.e. autoopen for any
        Lean file, or setting it to `false` is the same as `function() return false end`,
        i.e. never autoopen.
      '';

      autopause = helpers.defaultNullOpts.mkBool false "";

      width = helpers.defaultNullOpts.mkPositiveInt 50 ''
        Set infoview windows' starting width.
        Windows are opened horizontally or vertically depending on spacing.
      '';

      height = helpers.defaultNullOpts.mkPositiveInt 20 ''
        Set infoview windows' starting height.
        Windows are opened horizontally or vertically depending on spacing.
      '';

      horizontalPosition =
        helpers.defaultNullOpts.mkEnum
          [
            "top"
            "bottom"
          ]
          "bottom"
          ''
            Put the infoview on the top or bottom when horizontal.
          '';

      separateTab = helpers.defaultNullOpts.mkBool false ''
        Always open the infoview window in a separate tabpage.
        Might be useful if you are using a screen reader and don't want too many dynamic updates
        in the terminal at the same time.
        Note that `height` and `width` will be ignored in this case.
      '';

      indicators =
        helpers.defaultNullOpts.mkEnum
          [
            "always"
            "never"
            "auto"
          ]
          "auto"
          ''
            Show indicators for pin locations when entering an infoview window.
            `"auto"` = only when there are multiple pins.
          '';

      lean3 = {
        showFilter = helpers.defaultNullOpts.mkBool true "";

        mouseEvents = helpers.defaultNullOpts.mkBool false ''
          Setting this to `true` will simulate mouse events in the Lean 3 infoview, this is buggy
          at the moment so you can use the I/i keybindings to manually trigger these.
        '';
      };

      showProcessing = helpers.defaultNullOpts.mkBool true "";

      showNoInfoMessage = helpers.defaultNullOpts.mkBool false "";

      useWidgets = helpers.defaultNullOpts.mkBool true "Whether to use widgets.";

      mappings = helpers.defaultNullOpts.mkAttrsOf types.str {
        K = "click";
        "<CR>" = "click";
        gd = "go_to_def";
        gD = "go_to_decl";
        gy = "go_to_type";
        I = "mouse_enter";
        i = "mouse_leave";
        "<Esc>" = "clear_all";
        C = "clear_all";
        "<LocalLeader><Tab>" = "goto_last_window";
      } "Mappings.";
    };

    progressBars = {
      enable = helpers.defaultNullOpts.mkBool true ''
        Whether to enable the progress bars.
      '';

      priority = helpers.defaultNullOpts.mkUnsignedInt 10 ''
        Use a different priority for the signs.
      '';
    };

    stderr = {
      enable = helpers.defaultNullOpts.mkBool true ''
        Redirect Lean's stderr messages somewhere (to a buffer by default).
      '';

      height = helpers.defaultNullOpts.mkPositiveInt 5 "Height of the window.";

      onLines = helpers.defaultNullOpts.mkLuaFn "nil" ''
        A callback which will be called with (multi-line) stderr output.

        e.g., use:
        ```nix
          onLines = "function(lines) vim.notify(lines) end";
        ```
        if you want to redirect stderr to `vim.notify`.
        The default implementation will redirect to a dedicated stderr
        window.
      '';
    };

    lsp3 = helpers.defaultNullOpts.mkNullable (
      with types;
      submodule {
        freeformType = types.attrs;
        options = {
          enable = helpers.defaultNullOpts.mkBool true ''
              Whether to enable the legacy Lean 3 language server ?

              Set to `false` to disable, otherwise should be a table of options to pass to
            `lean3ls`.
            See https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lean3ls
              for details.
          '';

          on_attach = helpers.mkNullOrOption types.str "The LSP handler.";
        };
      }
    ) { } "Legacy Lean3 LSP settings.";
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];

    assertions = [
      {
        assertion =
          !(
            # leanls lsp server is disabled in nvim-lspconfig
            config.plugins.lsp.servers.leanls.enable
            # lsp is not (!) disabled in the lean.nvim plugin
            && !(
              # lsp is explicitly set to `false`.
              (isBool cfg.lsp.enable) && !cfg.lsp.enable
            )
          );
        message = ''
          You have not explicitly set `plugins.lean.lsp` to `false` while having `plugins.lsp.servers.leanls.enable` set to `true`.
          You need to either

            - Remove the configuration in `plugins.lsp.servers.leanls` and move it to `plugins.lean.lsp`.
            - Explicitly disable the autoconfiguration of the lsp in the lean.nvim plugin by setting `plugins.lean.lsp` to `false`.

          https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#leanls
        '';
      }
    ];

    extraPackages = [ cfg.leanPackage ];

    extraConfigLua =
      let
        setupOptions =
          with cfg;
          {
            inherit lsp;
            ft = with ft; {
              inherit default nomodifiable;
            };
            abbreviations = with abbreviations; {
              inherit enable extra leader;
            };
            inherit mappings;
            infoview = with infoview; {
              inherit
                autoopen
                autopause
                width
                height
                ;
              horizontal_position = horizontalPosition;
              separate_tab = separateTab;
              inherit indicators;
              lean3 = with lean3; {
                show_filter = showFilter;
                mouse_events = mouseEvents;
              };
              show_processing = showProcessing;
              show_no_info_message = showNoInfoMessage;
              use_widgets = useWidgets;
              inherit mappings;
            };
            progress_bars = with progressBars; {
              inherit enable priority;
            };
            stderr = with stderr; {
              inherit enable height;
              on_lines = onLines;
            };
            inherit lsp3;
          }
          // cfg.extraOptions;
      in
      ''
        require("lean").setup(${lib.nixvim.toLuaObject setupOptions})
      '';
  };
}
