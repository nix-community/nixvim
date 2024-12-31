{
  makeNixvimWithModule,
  runCommandLocal,
}:
let
  firstStage = makeNixvimWithModule {
    module = {
      extraConfigLua = "-- first stage";
    };
  };

  secondStage = firstStage.extend { extraConfigLua = "-- second stage"; };

  generated = secondStage.extend { extraConfigLua = "-- third stage"; };
in
runCommandLocal "extend-test" { printConfig = "${generated}/bin/nixvim-print-init"; } ''
  config=$($printConfig)
  for stage in "first" "second" "third"; do
    if ! "$printConfig" | grep -q -- "-- $stage stage"; then
      echo "Missing $stage stage in config"
      echo "$config"
      exit 1
    fi
  done

  touch $out
''
