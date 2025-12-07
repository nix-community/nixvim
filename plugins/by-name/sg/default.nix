{
  lib,
  config,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts literalLua;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "sg";
  package = "sg-nvim";
  description = "Experimental Sourcegraph + Cody plugin for Neovim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [ "nodejs" ];

  extraConfig = {
    plugins.sg.settings.node_executable = lib.mkIf config.dependencies.nodejs.enable (
      lib.mkDefault (lib.getExe config.dependencies.nodejs.package)
    );
  };

  settingsOptions = {
    enable_cody = defaultNullOpts.mkBool true ''
      Enable/disable cody integration.
    '';

    accept_tos = defaultNullOpts.mkBool false ''
      Accept the TOS without being prompted.
    '';

    chat = {
      default_model = defaultNullOpts.mkStr null ''
        The name of the default model to use for the chat.
      '';
    };

    download_binaries = defaultNullOpts.mkBool true ''
      Whether to download latest release from Github.

      WARNING: This should not be needed in Nixvim.
    '';

    node_executable = defaultNullOpts.mkStr "node" ''
      Path to the node executable.

      If you set `nodePackage` to a non-null package, this option will automatically default to its
      path.
    '';

    skip_node_check = defaultNullOpts.mkBool false ''
      Whether to skip node checks.

      Useful if using other js runtime.
    '';

    cody_agent = defaultNullOpts.mkStr (literalLua "vim.api.nvim_get_runtime_file('dist/cody-agent.js', false)[1]") ''
      Path to the cody-agent js bundle.
    '';

    on_attach =
      defaultNullOpts.mkRaw
        ''
          function(_, bufnr)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
            vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
          end
        ''
        ''
          Function to run when attaching to `sg://<file>` buffers.
        '';

    src_headers = defaultNullOpts.mkAttrsOf types.str null ''
      Headers to be sent with each `sg` request.
    '';
  };

  settingsExample = {
    enable_cody = true;
    accept_tos = true;
    skip_node_check = true;
  };
}
