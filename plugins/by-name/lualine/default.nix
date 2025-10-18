{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lualine";
  package = "lualine-nvim";
  description = "A blazing fast and easy to configure neovim statusline written in lua.";

  maintainers = [ lib.maintainers.khaneliman ];

  imports = [
    # TODO: added 2025-04-06, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "lualine";
      packageName = "git";
    })
  ];

  dependencies = [ "git" ];

  settingsOptions =
    let
      mkSeparatorsOption =
        { left, right }:
        defaultNullOpts.mkNullableWithRaw' {
          description = ''
            The left and right separators to use.
          '';
          pluginDefault = {
            inherit left right;
          };
          type =
            with types;
            either str (submodule {
              freeformType = attrsOf anything;

              options = {
                left = defaultNullOpts.mkStr left "Left separator";
                right = defaultNullOpts.mkStr right "Right separator";
              };
            });
        };

      # NOTE: This option is used for the shared component section definitions.
      # We used to transform several options for the user to handle unkeying inside an attribute set and
      # merging in undefined options into the final option. Now that we have freeformType support the user can
      # manage this configuration exactly as the plugin expects without us transforming the values for them.
      mkComponentOptions =
        description:
        lib.nixvim.mkNullOrOption' {
          type =
            with types;
            let
              # TODO: added 2024-09-05 remove after 24.11
              oldAttrs = [
                [ "name" ]
                [
                  "icon"
                  "icon"
                ]
                [ "extraConfig" ]
              ];
              isOldType = x: lib.any (loc: lib.hasAttrByPath loc x) oldAttrs;
              oldType = addCheck (attrsOf anything) isOldType // {
                description = "attribute set containing ${lib.concatMapStringsSep ", " lib.showOption oldAttrs}";
              };
              coerceFn =
                attrs:
                lib.pipe attrs [
                  # Transform old `name` attr to `__unkeyed`
                  (
                    x:
                    if x ? name then
                      lib.removeAttrs x [ "name" ]
                      // {
                        __unkeyed-1 = x.name;
                      }
                    else
                      x
                  )
                  # Transform old `icon.icon` attr to `__unkeyed`
                  (
                    x:
                    if x.icon or null ? icon then
                      x
                      // {
                        icon = removeAttrs x.icon [ "icon" ] // {
                          __unkeyed-1 = x.icon.icon;
                        };
                      }
                    else
                      x
                  )
                  # Merge in old `extraConfig` attr
                  (x: removeAttrs x [ "extraConfig" ] // x.extraConfig or { })
                ];
              newType = submodule {
                freeformType = attrsOf anything;

                options = {
                  icons_enabled = defaultNullOpts.mkBool true ''
                    Whether to display icons alongside the component.
                  '';

                  icon = lib.nixvim.mkNullOrOption' {
                    type = either str (attrsOf anything);
                    description = "The icon to be displayed in the component.";
                  };

                  separator = mkSeparatorsOption {
                    left = " ";
                    right = " ";
                  };

                  color = defaultNullOpts.mkNullable' {
                    type = either attrs str;
                    pluginDefault = lib.literalMD "The color defined by your theme, for the respective section & mode.";
                    description = "Defines a custom color for the component.";
                  };

                  padding = defaultNullOpts.mkNullable (oneOf [
                    int
                    (submodule {
                      # In case they add support for top/bottom padding
                      freeformType = attrsOf (maybeRaw int);

                      options = {
                        left = defaultNullOpts.mkInt null "Left padding.";
                        right = defaultNullOpts.mkInt null "Right padding.";
                      };
                    })
                    rawLua
                  ]) 1 "Amount of padding added to components.";

                  fmt = lib.nixvim.mkNullOrLuaFn' {
                    description = ''
                      A lua function to format the component string.
                    '';
                    example = ''
                      function(text)
                        return text .. "!!!"
                      end
                    '';
                  };
                };
              };
            in
            maybeRaw (listOf (either str (lib.nixvim.transitionType oldType coerceFn (maybeRaw newType))));
          inherit description;
        };

      mkEmptySectionOption = name: {
        lualine_a = mkComponentOptions "Left section on left side.";
        lualine_b = mkComponentOptions "Middle section on left side.";
        lualine_c = mkComponentOptions "Right section on left side.";
        lualine_x = mkComponentOptions "Left section on right side.";
        lualine_y = mkComponentOptions "Middle section on right side.";
        lualine_z = mkComponentOptions "Right section on right side.";
      };

    in
    {
      options = {
        icons_enabled = defaultNullOpts.mkBool true ''
          Whether to enable icons for all components.

          This option is also available on individual components to control whether they should display icons.
        '';

        theme = defaultNullOpts.mkNullable (
          with types; either str attrs
        ) "auto" "The theme to use for lualine-nvim.";

        component_separators = mkSeparatorsOption {
          left = "";
          right = "";
        };

        section_separators = mkSeparatorsOption {
          left = "";
          right = "";
        };

        disabled_filetypes = defaultNullOpts.mkNullableWithRaw' {
          description = ''
            Filetypes in which to disable lualine.
            Allows you to specify filetypes that you want to only disable on specific components.
          '';
          pluginDefault = { };
          type =
            with types;
            either (listOf (maybeRaw str)) (submodule {
              freeformType = attrsOf anything;

              options = {
                statusline = defaultNullOpts.mkListOf str [ ] ''
                  Hide the statusline component on specified filetypes.
                '';

                winbar = defaultNullOpts.mkListOf str [ ] ''
                  Hide the winbar component on specified filetypes.
                '';
              };
            });
        };

        ignore_focus = defaultNullOpts.mkNullableWithRaw' {
          type = types.listOf types.str;
          pluginDefault = [ ];
          description = ''
            A list of filetypes that should always show an "unfocused" statusline.

            If the focused window's filetype is in this list, then the most
            recently focused window will be drawn as the active statusline.
          '';
          example = [
            "neo-tree"
            "nvim-tree"
            "mini-files"
          ];
        };

        always_divide_middle = defaultNullOpts.mkBool true ''
          Whether to prevent left sections i.e. 'a','b' and 'c' from taking over the entire statusline
          even if neither of 'x', 'y' or 'z' are present.
        '';

        globalstatus = defaultNullOpts.mkBool false ''
          Whether to enable "global" statusline.
          I.e. having a single statusline at bottom of neovim, instead of one for each individual window.
        '';

        refresh = {
          statusline = defaultNullOpts.mkInt 1000 "Refresh time for the status line (ms)";

          tabline = defaultNullOpts.mkInt 1000 "Refresh time for the tabline (ms)";

          winbar = defaultNullOpts.mkInt 1000 "Refresh time for the winbar (ms)";
        };
      };

      sections = {
        lualine_a = mkComponentOptions "mode";
        lualine_b = mkComponentOptions "branch";
        lualine_c = mkComponentOptions "filename";

        lualine_x = mkComponentOptions "encoding";
        lualine_y = mkComponentOptions "progress";
        lualine_z = mkComponentOptions "location";
      };

      inactive_sections = {
        lualine_a = mkComponentOptions "";
        lualine_b = mkComponentOptions "";
        lualine_c = mkComponentOptions "filename";
        lualine_x = mkComponentOptions "location";
        lualine_y = mkComponentOptions "";
        lualine_z = mkComponentOptions "";
      };

      tabline = mkEmptySectionOption "Tabline configuration";

      winbar = mkEmptySectionOption "Winbar configuration.";

      inactive_winbar = mkEmptySectionOption "Winbar configuration used when inactive.";

      extensions = defaultNullOpts.mkListOf (with lib.types; either str (attrsOf anything)) [
      ] "List of enabled extensions.";
    };

  settingsExample = {
    options = {
      disabled_filetypes = {
        __unkeyed-1 = "startify";
        __unkeyed-2 = "neo-tree";
        statusline = [
          "dap-repl"
        ];
        winbar = [
          "aerial"
          "dap-repl"
          "neotest-summary"
        ];
      };
      globalstatus = true;
    };
    sections = {
      lualine_a = [ "mode" ];
      lualine_b = [ "branch" ];
      lualine_c = [
        "filename"
        "diff"
      ];
      lualine_x = [
        "diagnostics"
        {
          __unkeyed-1.__raw = ''
            function()
                local msg = ""
                local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                local clients = vim.lsp.get_active_clients()
                if next(clients) == nil then
                    return msg
                end
                for _, client in ipairs(clients) do
                    local filetypes = client.config.filetypes
                    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                        return client.name
                    end
                end
                return msg
            end
          '';
          icon = "";
          color.fg = "#ffffff";
        }
        "encoding"
        "fileformat"
        "filetype"
      ];
      lualine_y = [
        {
          __unkeyed-1 = "aerial";
          cond.__raw = ''
            function()
              local buf_size_limit = 1024 * 1024
              if vim.api.nvim_buf_get_offset(0, vim.api.nvim_buf_line_count(0)) > buf_size_limit then
                return false
              end

              return true
            end
          '';
          sep = " ) ";
          depth.__raw = "nil";
          dense = false;
          dense_sep = ".";
          colored = true;
        }
      ];
      lualine_z = [
        {
          __unkeyed-1 = "location";
        }
      ];
    };
    tabline = {
      lualine_a = [
        {
          __unkeyed-1 = "buffers";
          symbols = {
            alternate_file = "";
          };
        }
      ];
      lualine_z = [ "tabs" ];
    };
    winbar = {
      lualine_c = [
        {
          __unkeyed-1 = "navic";
        }
      ];
      lualine_x = [
        {
          __unkeyed-1 = "filename";
          newfile_status = true;
          path = 3;
          shorting_target = 150;
        }
      ];
    };
  };
}
