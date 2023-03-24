{
  example = {
    filetype = {
      extension = {
        foo = "fooscript";
        bar.__raw = ''
          function(path, bufnr)
            if some_condition() then
              return 'barscript', function(bufnr)
                -- Set a buffer variable
                vim.b[bufnr].barscript_version = 2
              end
            end
            return 'bar'
          end
        '';
      };
      filename = {
        ".foorc" = "toml";
        "/etc/foo/config" = "toml";
      };
      pattern = {
        ".*/etc/foo.*" = "fooscript";
        ".*/etc/foo.*%.conf" = [
          "dosini"
          {priority = 10;}
        ];
        "\${XDG_CONFIG_HOME}/foo/git" = "git";
        "README.(a+)$".__raw = ''
          function(path, bufnr, ext)
            if ext == 'md' then
              return 'markdown'
            elseif ext == 'rst' then
              return 'rst'
            end
          end
        '';
      };
    };
  };
}
