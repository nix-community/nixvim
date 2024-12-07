{
  example-with-str = {
    clipboard = {
      register = "unnamed";

      providers.xclip.enable = true;
    };
  };

  example-with-package = {
    clipboard = {
      register = [
        "unnamed"
        "unnamedplus"
      ];

      providers.xsel.enable = true;
    };
  };

  example-with-raw-lua = {
    clipboard = {
      register.__raw = ''vim.env.SSH_TTY and "" or "unnamedplus"'';
      providers.wl-copy.enable = true;
    };
  };
}
