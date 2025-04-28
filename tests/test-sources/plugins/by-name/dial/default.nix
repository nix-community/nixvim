{
  empty = {
    plugins.dial.enable = true;
  };

  example = {
    plugins.dial = {
      enable = true;

      luaConfig.content = ''
        local augend = require("dial.augend")
        require("dial.config").augends:register_group({
          default = {
            augend.integer.alias.decimal,
            augend.integer.alias.hex,
            augend.date.alias["%Y/%m/%d"],
            augend.constant.alias.bool,
            augend.semver.alias.semver,
            augend.constant.new({ elements = { "let", "const" } }),
          },
        })
      '';
    };
  };
}
