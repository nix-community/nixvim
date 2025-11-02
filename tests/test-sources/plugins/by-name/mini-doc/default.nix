{
  empty = {
    plugins.mini-doc.enable = true;
  };

  defaults = {
    plugins.mini-doc = {
      enable = true;
      settings = {
        annotation_pattern = "^%-%-%-(%S*) ?";
        default_section_id = "@text";
        script_path = "scripts/minidoc.lua";
        silent = true;
      };
    };
  };
}
