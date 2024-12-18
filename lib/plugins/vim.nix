{
  call,
  lib,
  self,
}:
{
  mkVimPlugin = call ./mk-vim-plugin.nix { };

  mkSettingsOptionDescription =
    { name, globalPrefix }:
    ''
      The configuration options for **${name}** without the `${globalPrefix}` prefix.

      For example, the following settings are equivialent to these `:setglobal` commands:
      - `foo_bar = 1` -> `:setglobal ${globalPrefix}foo_bar=1`
      - `hello = "world"` -> `:setglobal ${globalPrefix}hello="world"`
      - `some_toggle = true` -> `:setglobal ${globalPrefix}some_toggle`
      - `other_toggle = false` -> `:setglobal no${globalPrefix}other_toggle`
    '';

  mkSettingsOption =
    {
      options ? { },
      example ? { },
      name,
      globalPrefix,
    }:
    lib.nixvim.mkSettingsOption {
      inherit options example;
      description = self.vim.mkSettingsOptionDescription { inherit name globalPrefix; };
    };
}
