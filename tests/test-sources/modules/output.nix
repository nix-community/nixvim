{
  extraLuaPackages = {
    extraLuaPackages = ps: [ ps.jsregexp ];
    # Make sure jsregexp is in LUA_PATH
    extraConfigLua = ''require("jsregexp")'';
  };
}
