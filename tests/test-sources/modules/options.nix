{
  options = {
    opts = {
      updatetime = 100; # Faster completion

      # Line numbers
      relativenumber = true; # Relative line numbers
      number = true; # Display the absolute line number of the current line
      hidden = true; # Keep closed buffer open in the background
      mouse = "a"; # Enable mouse control
      mousemodel = "extend"; # Mouse right-click extends the current selection
    };

    localOpts = {
      textwidth = 80;
      sidescrolloff = 0;
    };

    globalOpts = {
      textwidth = 110;
      sidescrolloff = 10;
    };
  };

  globals = {
    globalsPre = ''
      dummy = 45
    '';
    globals = {
      with_pre.__raw = "dummy";
      loaded_ruby_provider = 0;
      loaded_perl_provider = 0;
      loaded_python_provider = 0;
    };
    globalsPost = # lua
      ''
        if vim.g.with_pre ~= dummy then
          print("Mismatch for vim.g.with_pre, expected " .. dummy .. " got " .. vim.g.with_pre)
        end
      '';
  };
}
