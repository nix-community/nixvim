{ pkgs, ... }:
# TODO: remove once https://github.com/NixOS/nixpkgs/pull/418842 hits flake.lock
pkgs.lib.optionalAttrs false {
  empty = {
    plugins.hurl.enable = true;
  };

  defaults = {
    plugins.hurl = {
      enable = true;

      settings = {
        debug = false;
        mode = "split";
        show_notification = false;
        auto_close = true;
        split_position = "right";
        split_size = "50%";
        popup_position = "50%";
        popup_size = {
          width = 80;
          height = 40;
        };
        env_file = [ "vars.env" ];
        fixture_vars = [
          {
            name = "random_int_number";
            callback.__raw = ''
              function()
                return math.random(1, 1000)
              end
            '';
          }
          {
            name = "random_float_number";
            callback.__raw = ''
              function()
                local result = math.random() * 10
                return string.format('%.2f', result)
              end
            '';
          }
        ];
        find_env_files_in_folders.__raw = "require('hurl.utils').find_env_files_in_folders";
        formatters = {
          json = [ "jq" ];
          html = [
            "prettier"
            "--parser"
            "html"
          ];
          xml = [
            "tidy"
            "-xml"
            "-i"
            "-q"
          ];
        };
      };
    };
  };

  example = {
    plugins.hurl = {
      enable = true;

      settings = {
        debug = true;
        mode = "popup";
        env_file = [ "vars.env" ];
        formatters = {
          json = [ "jq" ];
          html = [
            "prettier"
            "--parser"
            "html"
          ];
          xml = [
            "tidy"
            "-xml"
            "-i"
            "-q"
          ];
        };
      };
    };
  };
}
