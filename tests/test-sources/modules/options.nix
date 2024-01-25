{
  options = {
    options = {
      updatetime = 100; # Faster completion

      # Line numbers
      relativenumber = true; # Relative line numbers
      number = true; # Display the absolute line number of the current line
      hidden = true; # Keep closed buffer open in the background
      mouse = "a"; # Enable mouse control
      mousemodel = "extend"; # Mouse right-click extends the current selection
    };

    localOptions = {
      textwidth = 80;
      sidescrolloff = 0;
    };

    globalOptions = {
      textwidth = 110;
      sidescrolloff = 10;
    };
  };

  globals = {
    globals = {
      loaded_ruby_provider = 0;
      loaded_perl_provider = 0;
      loaded_python_provider = 0;
    };
  };
}
