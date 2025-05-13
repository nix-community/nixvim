{ lib, config, ... }:
let
  cfg = config.lsp;
in
{
  options.lsp = {
    onAttach = lib.mkOption {
      type = lib.types.lines;
      description = ''
        Lines of lua to be run when a language server is attached.

        > [!TIP]
        > The variables `client` and `bufnr` are made available in scope.

        This is a global equivialent to the per-server `on_attach` callback,
        which can be defined via `lsp.servers.<name>.settings.on_attach`.

        Unlike the per-server callback, which should be defined as a lua
        callback function, this option should be defined as the function body.
      '';
      default = "";
    };
  };

  config = lib.mkIf (cfg.onAttach != "") {
    autoGroups.nixvim_lsp_on_attach.clear = false;

    autoCmd = [
      {
        event = "LspAttach";
        group = "nixvim_lsp_on_attach";
        # `event` is documented in `:h event-args`:
        #   • id:    (number)     autocommand id
        #   • event: (string)     name of the triggered event
        #   • group: (number|nil) autocommand group id, if any
        #   • file:  (string)     <afile> (not expanded to a full path)
        #   • match: (string)     <amatch> (expanded to a full path)
        #   • buf:   (number)     <abuf>
        #   • data:  (any)        arbitrary data passed from `:h nvim_exec_autocmds()`
        #                         see `:h LspAttach`
        #
        # `:h event-args`: https://neovim.io/doc/user/api.html#event-args
        # `:h LspAttach`: https://neovim.io/doc/user/lsp.html#LspAttach
        callback = lib.nixvim.mkRaw ''
          function(event)
            do
              -- client and bufnr are supplied to the builtin `on_attach` callback,
              -- so make them available in scope for our global `onAttach` impl
              local client = vim.lsp.get_client_by_id(event.data.client_id)
              local bufnr = event.buf
              ${cfg.onAttach}
            end
          end
        '';
        desc = "Run LSP onAttach";
      }
    ];
  };
}
