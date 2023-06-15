{
  example = {
    plugins.lsp = {
      enable = true;

      servers.ccls = {
        enable = true;

        initOptions = {
          cache = {
            directory = ".ccls-cache";
            format = "binary";
            retainInMemory = 1;
          };
          clang = {
            extraArgs = [];
            excludeArgs = ["-frounding-math"];
            pathMappings = ["/remote/>/host/"];
            resourceDir = "";
          };
          client = {
            snippetSupport = true;
          };
          completion = {
            placeholder = false;
            detailedLabel = true;
            filterAndSort = true;
          };
          compilationDatabaseDirectory = "out/release";
          diagnostics = {
            onOpen = 0;
            onChange = 1000;
            onSave = 0;
          };
          index = {
            threads = 0;
            comments = 2;
            multiVersion = 0;
            multiVersionBlacklist = ["^/usr/include"];
            initialBlacklist = ["."];
            onChange = false;
            trackDependency = 2;
          };
        };
      };
    };
  };
}
