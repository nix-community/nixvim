{
  example-with-str = {
    clipboard = {
      register = "unnamed";

      providers.xclip.enable = true;
    };
  };

  example-with-package = {
    clipboard = {
      register = ["unnamed" "unnamedplus"];

      providers.xsel.enable = true;
    };
  };
}
