{
  empty = {
    plugins.conform.enable = true;
  };

  example = {
    plugins.conform = {
      enable = true;
      formatters_by_ft = {
        "lua" = ["stylua"];
        "python" = ["isort" "black"];
        "javascript" = [["prettierd" "prettier"]];
      };
    };
  };
}
