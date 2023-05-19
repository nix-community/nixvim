{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.plugins.barbar;
  helpers = import ../helpers.nix {inherit lib;};

  bufferOptions = {
    bufferIndex = helpers.mkNullOrOption types.bool ''
      Whether to show the index of the associated buffer with respect to the ordering of the
      buffers in the tabline.
    '';

    bufferNumber =
      helpers.mkNullOrOption types.bool
      "Whether to show the `bufnr` for the associated buffer.";

    button =
      helpers.mkNullOrOption (with types; either str (enum [false]))
      "the button which is clicked to close / save a buffer, or indicate that it is pinned.";

    diagnostics =
      helpers.mkCompositeOption "Diagnostics icons"
      (
        genAttrs
        ["error" "warn" "info" "hint"]
        (
          name:
            helpers.mkCompositeOption "${name} diagnostic icon" {
              enable = helpers.defaultNullOpts.mkBool false "Enable the ${name} diagnostic symbol";
              icon = helpers.mkNullOrOption types.str "${name} diagnostic symbol";
            }
        )
      );

    filetype = {
      customColors =
        helpers.defaultNullOpts.mkBool false
        "Sets the icon's highlight group. If false, will use nvim-web-devicons colors";

      enable = helpers.defaultNullOpts.mkBool true "Show the filetype icon.";
    };

    separator = {
      left = helpers.defaultNullOpts.mkStr "▎" "Left seperator";
      right = helpers.defaultNullOpts.mkStr "" "Right seperator";
    };
  };

  stateOptions =
    {
      modified = bufferOptions;
      pinned = bufferOptions;
    }
    // bufferOptions;

  keymaps = {
    previous = "Previous";
    next = "Next";
    movePrevious = "MovePrevious";
    moveNext = "MoveNext";
    goTo1 = "GoTo 1";
    goTo2 = "GoTo 2";
    goTo3 = "GoTo 3";
    goTo4 = "GoTo 4";
    goTo5 = "GoTo 5";
    goTo6 = "GoTo 6";
    goTo7 = "GoTo 7";
    goTo8 = "GoTo 8";
    goTo9 = "GoTo 9";
    last = "Last";
    pin = "Pin";
    close = "Close";
    pick = "Pick";
    orderByBufferNumber = "OrderByBufferNumber";
    orderByDirectory = "OrderByDirectory";
    orderByLanguage = "OrderByLanguage";
    orderByWindowNumber = "OrderByWindowNumber";
  };
in {
  options.plugins.barbar =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "barbar.nvim";

      package = helpers.mkPackageOption "barbar" pkgs.vimPlugins.barbar-nvim;

      animation = helpers.defaultNullOpts.mkBool true "Enable/disable animations";

      autoHide =
        helpers.defaultNullOpts.mkBool false
        "Enable/disable auto-hiding the tab bar when there is a single buffer.";

      tabpages =
        helpers.defaultNullOpts.mkBool true
        "Enable/disable current/total tabpages indicator (top right corner).";

      clickable = helpers.defaultNullOpts.mkBool true ''
        Enable clickable tabs
          - left-click: go to buffer
          - middle-click: delete buffer
      '';

      excludeFileTypes = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
        Excludes buffers of certain filetypes from the tabline
      '';

      excludeFileNames = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
        Excludes buffers with certain filenames from the tabline
      '';

      focusOnClose =
        helpers.defaultNullOpts.mkEnumFirstDefault ["left" "right"]
        ''
          A buffer to this direction will be focused (if it exists) when closing the current buffer.
        '';

      highlightAlternate = helpers.defaultNullOpts.mkBool false "Highlight alternate buffers";

      highlightInactiveFileIcons =
        helpers.defaultNullOpts.mkBool false
        "Highlight file icons in inactive buffers";

      highlightVisible = helpers.defaultNullOpts.mkBool true "Highlight visible buffers";

      icons =
        stateOptions
        // (
          mapAttrs (name: description:
            mkOption {
              type = types.submodule {
                options = stateOptions;
              };
              default = {};
              inherit description;
            })
          {
            alternate = "The icons used for an alternate buffer.";
            current = "The icons for the current buffer.";
            inactive = "The icons for inactive buffers.";
            visible = "The icons for visible buffers.";
          }
        );

      hide = {
        alternate = helpers.mkNullOrOption types.bool "Hide alternate buffers";
        current = helpers.mkNullOrOption types.bool "Hide current buffer";
        extensions = helpers.mkNullOrOption types.bool "Hide file extensions";
        inactive = helpers.mkNullOrOption types.bool "Hide inactive buffers";
        visible = helpers.mkNullOrOption types.bool "Hide visible buffers";
      };

      insertAtEnd = helpers.defaultNullOpts.mkBool false ''
        If true, new buffers will be inserted at the end of the list.
        Default is to insert after current buffer.
      '';

      insertAtStart = helpers.defaultNullOpts.mkBool false ''
        If true, new buffers will be inserted at the start of the list.
        Default is to insert after current buffer.
      '';

      maximumPadding =
        helpers.defaultNullOpts.mkInt 4
        "Sets the maximum padding width with which to surround each tab";

      minimumPadding =
        helpers.defaultNullOpts.mkInt 1
        "Sets the minimum padding width with which to surround each tab";

      maximumLength =
        helpers.defaultNullOpts.mkInt 30
        "Sets the maximum buffer name length.";

      semanticLetters = helpers.defaultNullOpts.mkBool true ''
        If set, the letters for each buffer in buffer-pick mode will be assigned based on their
        name.
        Otherwise or in case all letters are already assigned, the behavior is to assign letters in
        order of usability (see `letters` option)
      '';

      letters =
        helpers.defaultNullOpts.mkStr
        "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP"
        ''
          New buffer letters are assigned in this order.
          This order is optimal for the qwerty keyboard layout but might need adjustement for other layouts.
        '';

      sidebarFiletypes =
        helpers.mkNullOrOption
        (
          with types;
            attrsOf (
              either
              (enum [true])
              (types.submodule {
                options = {
                  text = helpers.mkNullOrOption types.str "The text used for the offset";

                  event =
                    helpers.mkNullOrOption types.str
                    "The event which the sidebar executes when leaving.";
                };
              })
            )
        )
        "Set the filetypes which barbar will offset itself for";

      noNameTitle = helpers.mkNullOrOption types.str ''
        Sets the name of unnamed buffers.
        By default format is "[Buffer X]" where X is the buffer number.
        But only a static string is accepted here.
      '';

      keymaps =
        {
          silent = mkEnableOption "silent keymaps for barbar";
        }
        // (
          mapAttrs
          (
            optionName: funcName:
              helpers.mkNullOrOption types.str "Keymap for function Buffer${funcName}"
          )
          keymaps
        );
    };

  config = let
    setupOptions =
      {
        inherit (cfg) animation;
        auto_hide = cfg.autoHide;
        inherit (cfg) tabpages;
        inherit (cfg) clickable;
        exclude_ft = cfg.excludeFileTypes;
        exclude_name = cfg.excludeFileNames;
        focus_on_close = cfg.focusOnClose;
        highlight_alternate = cfg.highlightAlternate;
        highlight_inactive_file_icons = cfg.highlightInactiveFileIcons;
        highlight_visible = cfg.highlightVisible;
        icons = let
          handleBufferOption = bufferOption:
            with bufferOption; {
              buffer_index = bufferIndex;
              buffer_number = bufferNumber;
              inherit button;
              diagnostics = helpers.ifNonNull' bufferOption.diagnostics (
                /*
                Because the keys of this lua table are not strings (but
                `vim.diagnostic.severity.XXXX`), we have to manualy build a raw lua string here.
                */
                let
                  setIcons = filterAttrs (n: v: v != null) cfg.icons.diagnostics;
                  setIconsList =
                    mapAttrsToList
                    (name: value: {
                      key = "vim.diagnostic.severity.${strings.toUpper name}";
                      value = helpers.ifNonNull' value (helpers.toLuaObject {
                        enabled = value.enable;
                        inherit (value) icon;
                      });
                    })
                    setIcons;
                in
                  helpers.mkRaw (
                    "{"
                    + concatStringsSep ","
                    (
                      map
                      (iconOption: "[${iconOption.key}] = ${iconOption.value}")
                      setIconsList
                    )
                    + "}"
                  )
              );
              filetype = with filetype; {
                custom_color = customColors;
                enabled = enable;
              };
              inherit separator;
            };

          handleStateOption = stateOption:
            with stateOption;
              {
                modified = handleBufferOption modified;
                pinned = handleBufferOption pinned;
              }
              // (
                handleBufferOption
                (
                  getAttrs (attrNames stateOption)
                  stateOption
                )
              );
        in
          (
            handleStateOption
            (
              getAttrs
              (attrNames stateOptions)
              cfg.icons
            )
          )
          // (
            genAttrs
            ["alternate" "current" "inactive" "visible"]
            (optionName: handleStateOption cfg.icons.${optionName})
          );
        inherit (cfg) hide;
        insert_at_end = cfg.insertAtEnd;
        insert_at_start = cfg.insertAtStart;
        maximum_padding = cfg.maximumPadding;
        minimum_padding = cfg.minimumPadding;
        maximum_length = cfg.maximumLength;
        semantic_letters = cfg.semanticLetters;
        inherit (cfg) letters;
        no_name_title = cfg.noNameTitle;
        sidebar_filetypes = cfg.sidebarFiletypes;
      }
      // cfg.extraOptions;

    userKeymapsList =
      mapAttrsToList
      (
        optionName: funcName: let
          key = cfg.keymaps.${optionName};
        in
          mkIf (!isNull key) {
            ${key} = {
              action = "<Cmd>Buffer${funcName}<CR>";
              silent = cfg.keymaps.silent;
            };
          }
      )
      keymaps;
  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [
        cfg.package
        nvim-web-devicons
      ];

      maps.normal = mkMerge userKeymapsList;

      extraConfigLua = ''
        require('bufferline').setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
