{
  empty = {
    plugins.jj-nvim.enable = true;
  };

  example = {
    plugins.snacks.enable = true;
    plugins.codediff.enable = true;

    plugins.jj-nvim = {
      enable = true;

      settings = {
        picker.snacks = { };
        diff.backend = "codediff";
        editor.auto_insert = true;
        terminal.window.type = "vsplit";
      };
    };
  };

  no-packages = {
    plugins.jj-nvim.enable = true;
    dependencies.jujutsu.enable = false;
  };
}
