{
  lib,
  config,
  ...
}:
let
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "zk";
  package = "zk-nvim";
  description = "Neovim extension for the [`zk`](https://github.com/zk-org/zk) plain text note-taking assistant.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [ "zk" ];

  settingsOptions = {
    picker =
      lib.nixvim.defaultNullOpts.mkEnumFirstDefault
        [
          "select"
          "fzf"
          "fzf_lua"
          "minipick"
          "telescope"
          "snacks_picker"
        ]
        ''
          It is recommended to use `"telescope"`, `"fzf"`, `"fzf_lua"`, `"minipick"` or `"snacks_picker"`.
        '';

    lsp = {
      config =
        lib.nixvim.defaultNullOpts.mkNullable
          (types.submodule {
            freeformType = with types; attrsOf anything;
            options = {
              cmd = lib.nixvim.defaultNullOpts.mkListOf types.str [
                "zk"
                "lsp"
              ] "Command to start the language server.";

              name = lib.nixvim.defaultNullOpts.mkStr "zk" ''
                The name for this server.
              '';

              on_attach = lib.nixvim.mkNullOrLuaFn ''
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
        enabled = lib.nixvim.defaultNullOpts.mkBool true ''
          Automatically attach buffers in a zk notebook.
        '';

        filetypes = lib.nixvim.defaultNullOpts.mkListOf types.str [ "markdown" ] ''
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

  extraConfig = cfg: opts: {
    warnings = lib.nixvim.mkWarnings "plugins.zk" (
      lib.mapAttrsToList
        (picker: pluginName: {
          when = (cfg.settings.picker == picker) && !config.plugins.${pluginName}.enable;
          message = ''
            You have defined `${opts.settings}.picker = "${picker}"` but `plugins.${pluginName}` is not enabled.
          '';
        })
        {
          fzf_lua = "fzf-lua";
          telescope = "telescope";
        }
    );
  };
}
