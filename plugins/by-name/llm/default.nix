{ lib, pkgs, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "llm";
  packPathName = "llm.nvim";
  package = "llm-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraOptions = {
    llmLsPackage = lib.mkPackageOption pkgs "llm-ls" {
      nullable = true;
    };
  };
  extraConfig = cfg: {
    extraPackages = [ cfg.llmLsPackage ];

    # If not setting this option, llm.nvim will try to download the llm-ls binary from the internet.
    plugins.llm.settings.lsp.bin_path = lib.mkIf (cfg.llmLsPackage != null) (
      lib.mkDefault (lib.getExe cfg.llmLsPackage)
    );
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
