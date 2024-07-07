{
  query = {
    extraFiles = {
      "testing/test-case.nix".source = ./extra-files.nix;
      "testing/123.txt".text = ''
        One
        Two
        Three
      '';
      "queries/lua/injections.scm".text = ''
        ;; extends
      '';
    };
  };
}
