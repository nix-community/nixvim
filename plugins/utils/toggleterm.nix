{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.toggleterm;

  directionOpt =
    helpers.defaultNullOpts.mkEnumFirstDefault
    ["vertical" "horizontal" "tab" "float"]
    "";

  closeOnExitOpt = helpers.defaultNullOpts.mkBool true ''
    Close the terminal window when the process exits.
  '';

  highlightsOpt = helpers.mkNullOrOption (with types; (attrsOf (attrsOf str))) ''
    Highlights which map to a highlight group name and a table of it's values.

    Example:
    ```nix
      highlights = {
        Normal = {
          guibg = "<VALUE-HERE>";
        };
        NormalFloat = {
          link = "Normal";
        },
        FloatBorder = {
          guifg = "<VALUE-HERE>";
          guibg = "<VALUE-HERE>";
        };
      };
    ```
  '';

  onOpenOpt = helpers.defaultNullOpts.mkLuaFn "nil" ''
    Function to run when the terminal opens.
  '';

  onCloseOpt = helpers.defaultNullOpts.mkLuaFn "nil" ''
    Function to run when the terminal closes.
  '';

  onStdoutOpt = helpers.defaultNullOpts.mkLuaFn "nil" ''
    Callback for processing output on stdout.
  '';

  onStderrOpt = helpers.defaultNullOpts.mkLuaFn "nil" ''
    Callback for processing output on stderr.
  '';

  onExitOpt = helpers.defaultNullOpts.mkLuaFn "nil" ''
    Function to run when terminal process exits.
  '';

  autoScrollOpt = helpers.defaultNullOpts.mkBool true ''
    Automatically scroll to the bottom on terminal output.
  '';
in {
  options.plugins.toggleterm = {
    enable = mkEnableOption "toggleterm";

    package = helpers.mkPackageOption "toggleterm" pkgs.vimPlugins.toggleterm-nvim;

    size = helpers.defaultNullOpts.mkStrLuaFnOr types.number "12" ''
      Size of the terminal.
      `size` can be a number or function
      Example:
      ```nix
      size = 20
      ```
      OR
      ```
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end
      ```
    '';

    openMapping = helpers.mkNullOrOption types.str ''
      Setting the open_mapping key to use for toggling the terminal(s) will set up mappings for
      normal mode.
    '';

    onCreate = helpers.defaultNullOpts.mkLuaFn "nil" ''
      Function to run when the terminal is first created.
    '';

    onOpen = onOpenOpt;

    onClose = onCloseOpt;

    onStdout = onStdoutOpt;

    onStderr = onStderrOpt;

    onExit = onExitOpt;

    hideNumbers = helpers.defaultNullOpts.mkBool true ''
      Hide the number column in toggleterm buffers.
    '';

    shadeFiletypes = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" "";

    autochdir = helpers.defaultNullOpts.mkBool false ''
      When neovim changes it current directory the terminal will change it's own when next it's
      opened.
    '';

    highlights = highlightsOpt;

    shadeTerminals = helpers.defaultNullOpts.mkBool false ''
      NOTE: This option takes priority over highlights specified so if you specify Normal highlights
      you should set this to false.
    '';

    shadingFactor = helpers.defaultNullOpts.mkInt (-30) ''
      The percentage by which to lighten terminal background.

      Default: -30 (gets multiplied by -3 if background is light).
    '';

    startInInsert = helpers.defaultNullOpts.mkBool true "";

    insertMappings = helpers.defaultNullOpts.mkBool true ''
      Whether or not the open mapping applies in insert mode.
    '';

    terminalMappings = helpers.defaultNullOpts.mkBool true ''
      Whether or not the open mapping applies in the opened terminals.
    '';

    persistSize = helpers.defaultNullOpts.mkBool true "";

    persistMode = helpers.defaultNullOpts.mkBool true ''
      If set to true (default) the previous terminal mode will be remembered.
    '';

    direction = directionOpt;

    closeOnExit = closeOnExitOpt;

    shell = helpers.defaultNullOpts.mkStr "`vim.o.shell`" ''
      Change the default shell.
    '';

    autoScroll = autoScrollOpt;

    floatOpts = {
      border =
        helpers.defaultNullOpts.mkBorder "single" "toggleterm"
        ''
          `border` = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by
          `win open`.
          The border key is *almost* the same as 'nvim_open_win'.
          The 'curved' border is a custom border type not natively supported but implemented in this plugin.
        '';

      width = helpers.defaultNullOpts.mkInt 50 "";

      height = helpers.defaultNullOpts.mkInt 50 "";

      winblend = helpers.defaultNullOpts.mkInt 3 "";

      zindex = helpers.defaultNullOpts.mkInt 50 "";
    };
    winbar = {
      enabled = helpers.defaultNullOpts.mkBool false "";

      nameFormatter =
        helpers.defaultNullOpts.mkLuaFn
        ''
          function(term)
            return term.name
          end
        '' "";
    };
    customTerms = let
      termConfig = types.submodule {
        options = {
          cmd = helpers.mkNullOrStr ''
            Command to execute when creating the terminal e.g. 'top'.
          '';
          keymap = helpers.mkNullOrStr ''
            Keymap to toggle the terminal.
          '';
          direction = directionOpt;
          dir = helpers.mkNullOrStr "The directory for the terminal.";
          name = helpers.mkNullOrStr "The name of the terminal.";
          hidden = helpers.defaultNullOpts.mkBool false ''
            Whether or not to include this terminal in the terminals list.
          '';
          closeOnExit = closeOnExitOpt;
          highlights = highlightsOpt;
          env = helpers.mkNullOrOption (with types; attrsOf str) ''
            key:value attribute set with environmental variables set in the terminal.
          '';
          clearEnv = helpers.defaultNullOpts.mkBool false ''
            Use only environmental variables from `env`.
          '';
          onOpen = onOpenOpt;
          onClose = onCloseOpt;
          autoScroll = autoScrollOpt;
          onStdout = onStdoutOpt;
          onStderr = onStderrOpt;
          onExit = onExitOpt;
        };
      };
    in
      mkOption {
        default = [];
        description = "Declare custom toggleterm terminals.";
        example = ''
          ```nix
          customTerms = [
            {
              cmd = "lazygit";
              keymap = "<leader>g";
              dir = "git_dir";
              direction = "float";
            }
          ];
          ```
        '';
        type = types.listOf termConfig;
      };
  };
  config = let
    setupOptions = with cfg; {
      inherit autochdir highlights direction shell size;
      open_mapping = helpers.ifNonNull' openMapping (helpers.mkRaw "[[${openMapping}]]");
      on_create = onCreate;
      on_open = onOpen;
      on_close = onClose;
      on_stdout = onStdout;
      on_stderr = onStderr;
      on_exit = onExit;
      hide_numbers = hideNumbers;
      shade_filetypes = shadeFiletypes;
      shade_terminals = shadeTerminals;
      shading_factor = shadingFactor;
      start_in_insert = startInInsert;
      insert_mappings = insertMappings;
      terminal_mappings = terminalMappings;
      persist_size = persistSize;
      persist_mode = persistMode;
      close_on_exit = closeOnExit;
      auto_scroll = autoScroll;
      float_opts = floatOpts;
      winbar = with winbar; {
        inherit enabled;
        name_formatter = nameFormatter;
      };
    };
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];
      extraConfigLua = ''
        require("toggleterm").setup(${helpers.toLuaObject setupOptions})
      '';
      keymaps = let
        customTermToMapping = tcfg: let
          termSetupOptions = with tcfg; {
            inherit cmd direction dir highlights;
            close_on_exit = closeOnExit;
            on_open = onOpen;
            on_close = onClose;
            auto_scroll = autoScroll;
            on_stdout = onStdout;
            on_stderr = onStderr;
            on_exit = onExit;
          };
        in {
          key = tcfg.keymap;
          action.__raw = ''
            function()
              local Terminal = require('toggleterm.terminal').Terminal
              Terminal:new(${helpers.toLuaObject termSetupOptions}):toggle()
            end
          '';
        };
        mappings = builtins.map customTermToMapping (
          builtins.filter (tcfg: tcfg.keymap != null) cfg.customTerms
        );
      in
        helpers.keymaps.mkKeymaps
        {
          mode = "n";
          options.silent = true;
        }
        mappings;
    };
}
