{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "zk";
  originalName = "zk.nvim";
  defaultPackage = pkgs.vimPlugins.zk-nvim;

  maintainers = [ maintainers.GaetanLepage ];

  # TODO: introduced 2024-06-28. Remove after 24.11 release.
  optionsRenamedToSettings = [
    "picker"
    [
      "lsp"
      "config"
    ]
    [
      "lsp"
      "autoAttach"
      "enabled"
    ]
    [
      "lsp"
      "autoAttach"
      "filetypes"
    ]
  ];

  settingsOptions = {
    picker =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "select"
          "fzf"
          "fzf_lua"
          "minipick"
          "telescope"
        ]
        ''
          It is recommended to use `"telescope"`, `"fzf"`, `"fzf_lua"`, or `"minipick"`.
        '';

    lsp = {
      config =
        helpers.defaultNullOpts.mkNullable
          (types.submodule {
            freeformType = with types; attrsOf anything;
            options = {
              cmd = helpers.defaultNullOpts.mkListOf types.str [
                "zk"
                "lsp"
              ] "Command to start the language server.";

              name = helpers.defaultNullOpts.mkStr "zk" ''
                The name for this server.
              '';

              on_attach = helpers.mkNullOrLuaFn ''
                Command to run when the client is attached.
              '';
            };
          })
          {
            cmd = [
              "zk"
              "lsp"
            ];
            name = "zk";
          }
          ''
            LSP configuration. See `:h vim.lsp.start_client()`.
          '';

      auto_attach = {
        enabled = helpers.defaultNullOpts.mkBool true ''
          Automatically attach buffers in a zk notebook.
        '';

        filetypes = helpers.defaultNullOpts.mkListOf types.str [ "markdown" ] ''
          Filetypes for which zk should automatically attach.
        '';
      };
    };
  };

  settingsExample = {
    picker = "telescope";
    lsp = {
      config = {
        cmd = [
          "zk"
          "lsp"
        ];
        name = "zk";
      };
      auto_attach = {
        enabled = true;
        filetypes = [ "markdown" ];
      };
    };

  };

  extraOptions = {
    zkPackage = helpers.mkPackageOption {
      name = "zk";
      default = pkgs.zk;
    };
  };
  extraConfig = cfg: {
    extraPackages = [ cfg.zkPackage ];

    warnings = flatten (
      mapAttrsToList
        (
          picker: pluginName:
          optional ((cfg.settings.picker == picker) && !config.plugins.${pluginName}.enable) ''
            Nixvim (plugins.zk): You have set `plugins.zk.settings.picker = "${picker}"` but `plugins.${pluginName}` is not enabled in your config.
          ''
        )
        {
          fzf_lua = "fzf-lua";
          telescope = "telescope";
        }
    );
  };
}
