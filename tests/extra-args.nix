{
  makeNixvimWithModule,
  runCommandLocal,
}:
let
  defaultModule =
    { regularArg, ... }:
    {
      extraConfigLua = ''
        -- regularArg=${regularArg}
      '';
    };
  generated = makeNixvimWithModule {
    module =
      { extraModule, ... }:
      {
        _module.args = {
          regularArg = "regularValue";
        };
        imports = [
          defaultModule
          extraModule
        ];
      };
    extraSpecialArgs = {
      extraModule = {
        extraConfigLua = ''
          -- specialArg=specialValue
        '';
      };
    };
  };
in
runCommandLocal "special-arg-test" { printConfig = "${generated}/bin/nixvim-print-init"; } ''
  config=$($printConfig)
  if ! "$printConfig" | grep -- '-- regularArg=regularValue'; then
    echo "Missing regularArg in config"
    exit 1
  fi
  if ! "$printConfig" | grep -- '-- specialArg=specialValue'; then
    echo "Missing specialArg in config"
    exit 1
  fi

  touch $out
''
