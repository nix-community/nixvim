{
  empty = {
    plugins.gitsigns.enable = true;
  };

  on_attach_str = {
    plugins.gitsigns = {
      enable = true;
      onAttach = ''
        function(_) end
      '';
    };
  };
}
