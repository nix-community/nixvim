{
  lib,
  config,
  options,
  ...
}:
let
  cfg = config.lsp;
  opts = options.lsp;

  # Isolate user code so `return` cannot skip the completion setup that follows.
  userOnAttachLua = lib.optionalString (cfg.onAttach != "") ''
    local function __nixvim_user_on_attach()
      ${cfg.onAttach}
    end

    __nixvim_user_on_attach()
  '';

  # Completion needs a client and buffer, so configure it per attached buffer.
  # Neovim snapshots `completionProvider.triggerCharacters` when completion is
  # enabled. Run this after `onAttach` so users can extend the list first. See
  # `:h lsp-attach` and `:h lsp-autocompletion`.
  # Pass `bufnr` because dynamic registration can target a non-current buffer.
  completionLua = lib.optionalString cfg.completion.enable ''
    if client:supports_method('textDocument/completion', bufnr) then
      vim.lsp.completion.enable(${lib.boolToString cfg.completion.activate}, client.id, bufnr${
        lib.optionalString (
          cfg.completion.settings != { }
        ) ", ${lib.nixvim.toLuaObject cfg.completion.settings}"
      })
    end
  '';
in
{
  options.lsp = {
    completion = {
      enable = lib.mkEnableOption null // {
        description = ''
          Whether Nixvim manages `vim.lsp.completion` for attached clients that
          support `textDocument/completion`.

          See [`:h lsp-completion`](https://neovim.io/doc/user/lsp/#lsp-completion)
        '';
      };

      activate = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = ''
          Value passed to `vim.lsp.completion.enable()`. To disable completion,
          set `${opts.completion.enable}` to `true` and this option to `false`.
        '';
      };

      settings = lib.nixvim.mkSettingsOption {
        description = ''
          Options passed to `vim.lsp.completion.enable()`.
        '';
        example = {
          autotrigger = true;
        };
      };
    };

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

  config = lib.mkIf (cfg.onAttach != "" || cfg.completion.enable) {
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
              if client == nil then
                return
              end

              __nixvim_lsp_on_attach(client, event.buf, event)
            end
          end
        '';
        desc = "Run LSP onAttach";
      }
    ];

    extraConfigLua = ''
      local function __nixvim_lsp_on_attach(client, bufnr, event)
        ${userOnAttachLua}
        ${completionLua}
      end

      vim.lsp.handlers["client/registerCapability"] = (function(overridden)
        return function(err, res, ctx, ...)
          local result = overridden(err, res, ctx, ...)
          local client = vim.lsp.get_client_by_id(ctx.client_id)
          if client == nil then
            return result
          end

          for bufnr, _ in pairs(client.attached_buffers) do
            __nixvim_lsp_on_attach(client, bufnr, {
              buf = bufnr,
              data = {
                client_id = client.id,
              },
            })
          end

          return result
        end
      end)(vim.lsp.handlers["client/registerCapability"])
    '';
  };
}
