{
  # empty test case is not needed since having it would make the warning throw an error
  # this plugin requires which-key
  combine-plugins = {
    plugins.which-key.enable = true;
    plugins.yaml-schema-detect.enable = true;
  };
}
