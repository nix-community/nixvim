{ pkgs, ... }:
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

      # wl-copy is only available on linux
      providers.wl-copy.enable = pkgs.stdenv.hostPlatform.isLinux;
    };
  };

  example-with-builtin = {
    clipboard = {
      # pbcopy is only available on darwin, and is built-in
      providers.pbcopy.enable = pkgs.stdenv.hostPlatform.isDarwin;
    };
  };
}
