{
  empty = {
    plugins.mini-trailspace.enable = true;
  };

  example = {
    plugins.mini-trailspace = {
      enable = true;
      settings = {
        only_in_normal_buffers = false;
      };
    };
  };
}
