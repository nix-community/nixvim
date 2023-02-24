{lib}: let
  # List of files containing configurations
  pluginFiles =
    builtins.filter (p: p != "default.nix") (builtins.attrNames (builtins.readDir ./.));

  /*
  Create a list of tests. The list is of the form:
    [ { name = "<plugin>-<test_name>"; value = { ... }; } ]
  */
  makePluginTests = pluginFile: let
    pluginName = builtins.head (lib.strings.splitString "." pluginFile);
    pluginConfigs = import (./. + "/${pluginFile}");
  in
    lib.attrsets.mapAttrsToList (testName: testConfig: {
      name = "${pluginName}-${testName}";
      value = testConfig;
    })
    pluginConfigs;

  # A list of lists of test cases for each plugin
  pluginTests = builtins.map makePluginTests pluginFiles;
in
  builtins.listToAttrs (lib.lists.flatten pluginTests)
