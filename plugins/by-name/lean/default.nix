{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts mkNullOrOption;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lean";
  packPathName = "lean.nvim";
  package = "lean-nvim";
  description = "Neovim support for the Lean theorem prover.";

  maintainers = [ lib.maintainers.khaneliman ];

  dependencies = [ "lean" ];

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "lean";
      packageName = "lean";
    })
  ];

  settingsOptions = {
    lsp = defaultNullOpts.mkNullable (types.submodule {
      freeformType = types.attrsOf types.anything;
      options = {
        enable = defaultNullOpts.mkBool true ''
          Whether to enable the Lean language server(s).

          Set to `false` to disable, otherwise should be a table of options to pass to
          `leanls`.

          See https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#leanls
          for details.
        '';

        on_attach = mkNullOrOption types.str ''
          The LSP handler.
        '';

        init_options = mkNullOrOption (with types; attrsOf anything) ''
          The options to configure the lean language server.

          See `Lean.Lsp.InitializationOptions` for details.
        '';
      };
    }) { } "LSP settings.";
    ft = {
      default = defaultNullOpts.mkStr "lean" ''
        The default filetype for Lean files.
      '';
      nomodifiable = mkNullOrOption (types.listOf types.str) ''
        A list of patterns which will be used to protect any matching Lean file paths from being
        accidentally modified (by marking the buffer as `nomodifiable`).

        By default, this list includes the Lean standard libraries, as well as files within
        dependency directories (e.g. `_target`)

        Set this to an empty table to disable.
      '';
    };
    abbreviations = {
      enable = defaultNullOpts.mkBool true ''
        Whether to enable expanding of unicode abbreviations.
      '';
      extra = defaultNullOpts.mkAttrsOf' {
        type = types.str;
        pluginDefault = { };
        description = ''
          Additional abbreviations.
        '';
        example = lib.literalExpression ''
          ```nix
          {
            # Add a \wknight abbreviation to insert ♘
            #
            # Note that the backslash is implied, and that you of
            # course may also use a snippet engine directly to do
            # this if so desired.
            wknight = "♘";
          }
        '';
      };
      leader = defaultNullOpts.mkStr "\\" ''
        Change if you don't like the backslash.
      '';
    };
    mappings = defaultNullOpts.mkBool false ''
      Whether to enable suggested mappings.
    '';
    infoview = {
      autoopen = defaultNullOpts.mkBool true ''
        Automatically open an infoview on entering a Lean buffer.

        Should be a function that will be called anytime a new Lean file is opened.
        Return true to open an infoview, otherwise false.
        Setting this to `true` is the same as `function() return true end`, i.e. autoopen for any
        Lean file, or setting it to `false` is the same as `function() return false end`,
        i.e. never autoopen.
      '';
      autopause = defaultNullOpts.mkBool false "Set whether a new pin is automatically paused.";
      width = defaultNullOpts.mkPositiveInt 50 ''
        Set infoview windows' starting width.
      '';
      height = defaultNullOpts.mkPositiveInt 20 ''
        Set infoview windows' starting height.
      '';
      horizontal_position = defaultNullOpts.mkEnumFirstDefault [ "bottom" "top" ] ''
        Put the infoview on the top or bottom when horizontal.
      '';
      separate_tab = defaultNullOpts.mkBool false ''
        Always open the infoview window in a separate tabpage.
        Might be useful if you are using a screen reader and don't want too many dynamic updates
        in the terminal at the same time.

        Note that `height` and `width` will be ignored in this case.
      '';
      indicators = defaultNullOpts.mkEnumFirstDefault [ "auto" "always" "never" ] ''
        Show indicators for pin locations when entering an infoview window.
      '';
      show_processing = defaultNullOpts.mkBool true "";
      show_no_info_message = defaultNullOpts.mkBool false "";
      use_widgets = defaultNullOpts.mkBool true "Whether to use widgets.";
      mappings = defaultNullOpts.mkAttrsOf types.str {
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
    progress_bars = {
      enable = defaultNullOpts.mkBool true ''
        Whether to enable the progress bars.
      '';
      priority = defaultNullOpts.mkUnsignedInt 10 ''
        Use a different priority for the signs.
      '';
    };
    stderr = {
      enable = defaultNullOpts.mkBool true ''
        Redirect Lean's stderr messages somewhere (to a buffer by default).
      '';
      height = defaultNullOpts.mkPositiveInt 5 "Height of the window.";
      on_lines = defaultNullOpts.mkLuaFn "nil" ''
        A callback which will be called with (multi-line) stderr output.
      '';
    };
  };

  settingsExample = {
    settings = {
      lsp = {
        enable = true;
      };
      ft = {
        default = "lean";
        nomodifiable = [ "_target" ];
      };
      abbreviations = {
        enable = true;
        extra = {
          wknight = "♘";
        };
      };
      mappings = false;
      infoview = {
        horizontal_position = "top";
        separate_tab = true;
        indicators = "always";
      };
      progress_bars = {
        enable = false;
      };
      stderr = {
        on_lines.__raw = "function(lines) vim.notify(lines) end";
      };
    };
  };

  # TODO: Deprecated in 2025-01-31
  inherit (import ./deprecations.nix) deprecateExtraOptions optionsRenamedToSettings;
}
