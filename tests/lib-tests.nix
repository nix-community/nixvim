# For shorter test iterations run the following in the root of the repo:
#   `echo ':b checks.${builtins.currentSystem}.lib-tests' | nix repl .`
{
  pkgs,
  lib,
}: let
  helpers = import ../lib/helpers.nix {inherit pkgs lib;};
  results = pkgs.lib.runTests {
    testToLuaObject = {
      expr = helpers.toLuaObject {
        foo = "bar";
        qux = [1 2 3];
      };
      expected = ''{["foo"] = "bar",["qux"] = {1,2,3}}'';
    };

    testToLuaObjectRawLua = {
      expr = helpers.toLuaObject {
        __raw = "<lua code>";
      };
      expected = "<lua code>";
    };

    testToLuaObjectLuaTableMixingList = {
      expr = helpers.toLuaObject {
        "@...." = "foo";
        bar = "baz";
      };
      expected = ''{"foo",["bar"] = "baz"}'';
    };

    testToLuaObjectNestedAttrs = {
      expr = helpers.toLuaObject {
        a = {
          b = 1;
          c = 2;
          d = {e = 3;};
        };
      };
      expected = ''{["a"] = {["b"] = 1,["c"] = 2,["d"] = {["e"] = 3}}}'';
    };

    testToLuaObjectNestedList = {
      expr = helpers.toLuaObject [1 2 [3 4 [5 6]] 7];
      expected = "{1,2,{3,4,{5,6}},7}";
    };

    testToLuaObjectNonStringPrims = {
      expr = helpers.toLuaObject {
        a = 1.0;
        b = 2;
        c = true;
        d = false;
        e = null;
      };
      expected = ''{["a"] = 1.000000,["b"] = 2,["c"] = true,["d"] = false}'';
    };

    testToLuaObjectNilPrim = {
      expr = helpers.toLuaObject null;
      expected = "nil";
    };

    testToLuaObjectStringPrim = {
      expr = helpers.toLuaObject ''
        foo\bar
        baz'';
      expected = ''"foo\\bar\nbaz"'';
    };

    testToLuaObjectFilters = {
      expr = helpers.toLuaObject {
        a = null;
        b = {};
        c = [];
        d = {
          e = null;
          f = {};
        };
      };
      expected = ''{}'';
    };

    testToLuaObjectEmptyTable = {
      expr = helpers.toLuaObject {
        a = null;
        b = {};
        c = {__empty = null;};
        d = {
          e = null;
          f = {};
          g = helpers.emptyTable;
        };
      };
      expected = ''{["c"] = { },["d"] = {["g"] = { }}}'';
    };
  };
in
  if results == []
  then pkgs.runCommand "lib-tests-success" {} "touch $out"
  else
    pkgs.runCommand "lib-tests-failure" {
      results = pkgs.lib.concatStringsSep "\n" (
        builtins.map (result: ''
          ${result.name}:
            expected: ${result.expected}
            result: ${result.result}
        '')
        results
      );
    } ''
      echo -e "Tests failed:\\n\\n$results" >&2
      exit 1
    ''
