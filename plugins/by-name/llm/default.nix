{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "llm";
  packPathName = "llm.nvim";
  package = "llm-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [ "llm-ls" ];

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "llm";
      packageName = "llm-ls";
      oldPackageName = "llmLs";
    })
  ];

  extraConfig = {
    # If not setting this option, llm.nvim will try to download the llm-ls binary from the internet.
    plugins.llm.settings.lsp.bin_path =
      let
        llm-ls-dep = config.dependencies.llm-ls;
      in
      lib.mkIf llm-ls-dep.enable (lib.mkDefault (lib.getExe llm-ls-dep.package));
  };

  settingsOptions = import ./settings-options.nix lib;

  settingsExample = {
    max_tokens = 1024;
    url = "https://open.bigmodel.cn/api/paas/v4/chat/completions";
    model = "glm-4-flash";
    prefix = {
      user = {
        text = "😃 ";
        hl = "Title";
      };
      assistant = {
        text = "⚡ ";
        hl = "Added";
      };
    };
    save_session = true;
    max_history = 15;
    keys = {
      "Input:Submit" = {
        mode = "n";
        key = "<cr>";
      };
      "Input:Cancel" = {
        mode = "n";
        key = "<C-c>";
      };
    };
  };
}
