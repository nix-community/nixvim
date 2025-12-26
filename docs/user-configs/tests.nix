{
  lib,
  testers,
  writeText,
  drv, # The derivation under test
}:
let
  mkFile = name: v: if lib.isPath v then v else writeText name v;

  overrideSrc =
    src:
    drv.overrideAttrs {
      inherit src;
    };

  expectEqualContent =
    {
      message,
      expected,
      input,
    }:
    testers.testEqualContents {
      assertion = message;
      actual = overrideSrc (mkFile "${message}-input" input);
      expected = mkFile "${message}-expected" expected;
    };
in
# TODO: introduce some negative cases for input that should fail
{
  maintainers = expectEqualContent {
    message = "integration test: maintainers";
    input = ''
      [[config]]
      owner = "GaetanLepage"
      title = "nix-config"
      description = "Home-manager"
      url = "https://github.com/GaetanLepage/nix-config/tree/master/home/modules/tui/neovim"

      [[config]]
      owner = "khaneliman"
      repo = "khanelivim"
      description = "Constantly tweaked jack of all trades development focused configuration."

      [[config]]
      owner = "MattSturgeon"
      repo = "nix-config"

      [[config]]
      owner = "traxys"
      title = "Nixfiles"
      url = "https://github.com/traxys/Nixfiles/tree/master/neovim"
    '';
    expected = ''
      | Owner | Config | Comment |
      |-------|--------|---------|
      | [GaetanLepage](https://github.com/GaetanLepage) | [nix-config](https://github.com/GaetanLepage/nix-config/tree/master/home/modules/tui/neovim) | Home-manager |
      | [khaneliman](https://github.com/khaneliman) | [khanelivim](https://github.com/khaneliman/khanelivim) | Constantly tweaked jack of all trades development focused configuration. |
      | [MattSturgeon](https://github.com/MattSturgeon) | [nix-config](https://github.com/MattSturgeon/nix-config) |  |
      | [traxys](https://github.com/traxys) | [Nixfiles](https://github.com/traxys/Nixfiles/tree/master/neovim) |  |
    '';
  };

  simple = expectEqualContent {
    message = "unit test: simple";
    input = ''
      [[config]]
      owner = "Simon"
      title = "Says"
      url = "url"
    '';
    expected = ''
      | Owner | Config | Comment |
      |-------|--------|---------|
      | [Simon](https://github.com/Simon) | [Says](url) |  |
    '';
  };

  simple-description = expectEqualContent {
    message = "unit test: simple with description";
    input = ''
      [[config]]
      owner = "Simon"
      title = "Says"
      url = "url"
      description = "desc"
    '';
    expected = ''
      | Owner | Config | Comment |
      |-------|--------|---------|
      | [Simon](https://github.com/Simon) | [Says](url) | desc |
    '';
  };

  description-with-lines = expectEqualContent {
    message = "unit test: description with linebreaks";
    input = ''
      [[config]]
      owner = "sloppy"
      title = "title"
      url = "url"
      description = """

      This description

      Contains

      Many
      Line
      breaks


      """
    '';
    expected = ''
      | Owner | Config | Comment |
      |-------|--------|---------|
      | [sloppy](https://github.com/sloppy) | [title](url) | This description Contains Many Line breaks |
    '';
  };

  title-with-lines = expectEqualContent {
    message = "unit test: title with linebreaks";
    input = ''
      [[config]]
      owner = "sloppy"
      title = """

      This title

      Contains

      Many
      Line
      breaks


      """
      url = "url"
    '';
    expected = ''
      | Owner | Config | Comment |
      |-------|--------|---------|
      | [sloppy](https://github.com/sloppy) | [This title Contains Many Line breaks](url) |  |
    '';
  };
}
