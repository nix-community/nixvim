{
  makeNixvimWithModule,
  pkgs,
}: let
  generated = makeNixvimWithModule {
    module = {importedArgument, ...}: {
      extraConfigLua = ''
        -- importedArgument=${importedArgument}
      '';
    };
    extraSpecialArgs = {
      importedArgument = "foobar";
    };
  };
in
  pkgs.runCommand "special-arg-test" {
    printConfig = "${generated}/bin/nixvim-print-init";
  } ''
    config=$($printConfig)
    if ! "$printConfig" | grep -- '-- importedArgument=foobar'; then
      echo "Missing importedArgument in config"
      exit 1
    fi

    touch $out
  ''
