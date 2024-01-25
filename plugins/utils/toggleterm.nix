{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.toggleterm;
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

    onOpen = helpers.defaultNullOpts.mkLuaFn "nil" ''
      Function to run when the terminal opens.
    '';

    onClose = helpers.defaultNullOpts.mkLuaFn "nil" ''
      Function to run when the terminal closes.
    '';

    onStdout = helpers.defaultNullOpts.mkLuaFn "nil" ''
      Callback for processing output on stdout.
    '';

    onStderr = helpers.defaultNullOpts.mkLuaFn "nil" ''
      Callback for processing output on stderr.
    '';

    onExit = helpers.defaultNullOpts.mkLuaFn "nil" ''
      Function to run when terminal process exits.
    '';

    hideNumbers = helpers.defaultNullOpts.mkBool true ''
      Hide the number column in toggleterm buffers.
    '';

    shadeFiletypes = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" "";

    autochdir = helpers.defaultNullOpts.mkBool false ''
      When neovim changes it current directory the terminal will change it's own when next it's
      opened.
    '';

    highlights = helpers.mkNullOrOption (with types; (attrsOf (attrsOf str))) ''
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

    direction =
      helpers.defaultNullOpts.mkEnumFirstDefault
      ["vertical" "horizontal" "tab" "float"]
      "";

    closeOnExit = helpers.defaultNullOpts.mkBool true ''
      Close the terminal window when the process exits.
    '';

    shell = helpers.defaultNullOpts.mkStr "`vim.o.shell`" ''
      Change the default shell.
    '';

    autoScroll = helpers.defaultNullOpts.mkBool true ''
      Automatically scroll to the bottom on terminal output.
    '';

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
    };
}
