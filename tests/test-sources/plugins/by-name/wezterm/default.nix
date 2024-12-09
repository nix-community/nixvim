{
  empty =
    { pkgs, ... }:
    {
      plugins.wezterm = {
        enable = true;
        weztermPackage = pkgs.wezterm;
      };
    };

  defaults =
    { pkgs, ... }:
    {
      plugins.wezterm = {
        enable = true;
        weztermPackage = pkgs.wezterm;

        settings = {
          create_commands = true;
        };
      };
    };
}
