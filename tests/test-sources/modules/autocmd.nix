{
  example = {
    autoCmd = [
      {
        event = [
          "BufEnter"
          "BufWinEnter"
        ];
        pattern = [
          "*.c"
          "*.h"
        ];
        callback = {
          __raw = "function() print('This buffer enters') end";
        };
      }
      {
        event = "InsertEnter";
        command = "norm zz";
      }
    ];
  };
}
