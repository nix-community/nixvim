{ config, lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "claude-fzf";
  package = "claude-fzf-nvim";
  description = "Fzf-lua pickers for adding files, buffers, and search results to claudecode.nvim's context.";

  maintainers = [ lib.maintainers.khaneliman ];

  extraConfig = {
    assertions = lib.nixvim.mkAssertions "plugins.claude-fzf" [
      {
        assertion = config.plugins.fzf-lua.enable;
        message = ''
          You have to enable `plugins.fzf-lua` to use `plugins.claude-fzf`.
        '';
      }
      {
        assertion = config.plugins.claudecode.enable;
        message = ''
          You have to enable `plugins.claudecode` to use `plugins.claude-fzf`.
        '';
      }
    ];
  };

  settingsExample = lib.literalExpression ''
    {
      batch_size = 10;
      keymaps = {
        files = "<leader>acF";
        grep = "<leader>acg";
        buffers = "<leader>acB";
        git_files = "<leader>acG";
        directory_files = "<leader>acD";
      };
      fzf_opts = {
        preview = {
          border = "rounded";
        };
        winopts = {
          width = 0.7;
        };
      };
    }
  '';
}
