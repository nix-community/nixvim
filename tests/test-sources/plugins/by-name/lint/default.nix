{
  empty = {
    plugins.lint.enable = true;
  };

  example = {
    plugins.lint = {
      enable = true;

      lintersByFt = {
        text = [ "vale" ];
        json = [ "jsonlint" ];
        markdown = [ "vale" ];
        rst = [ "vale" ];
        ruby = [ "ruby" ];
        janet = [ "janet" ];
        inko = [ "inko" ];
        clojure = [ "clj-kondo" ];
        dockerfile = [ "hadolint" ];
        terraform = [ "tflint" ];
      };
      linters = {
        phpcs.args = [
          "-q"
          "--report=json"
          "-"
        ];
      };
      customLinters = {
        foo = {
          cmd = "foo_cmd";
          stdin = true;
          append_fname = false;
          args = [ ];
          stream = "stderr";
          ignore_exitcode = false;
          env = {
            FOO = "bar";
          };
          parser = ''
            require('lint.parser').from_pattern(pattern, groups, severity_map, defaults, opts)
          '';
        };
        foo2 = {
          cmd = "foo2_cmd";
          parser = ''
            require('lint.parser').from_pattern(pattern, groups, severity_map, defaults, opts)
          '';
        };
        bar.__raw = ''
          function()
            return {
              cmd = "foo_cmd",
              stdin = true,
              append_fname = false,
              args = {},
              stream = "stderr",
              ignore_exitcode = false,
              env = {
                ["FOO"] = "bar",
              },
              parser = require('lint.parser').from_pattern(pattern, groups, severity_map, defaults, opts),
            }
          end
        '';
      };
    };
  };
}
