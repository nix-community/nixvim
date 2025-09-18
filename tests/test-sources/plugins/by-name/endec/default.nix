{
  empty = {
    plugins.endec.enable = true;
  };

  defaults = {
    plugins.endec = {
      enable = true;
      settings = {
        keymaps = {
          defaults = true;
          decode_base64_inplace = "gyb";
          vdecode_base64_inplace = "gyb";
          decode_base64_popup = "gb";
          vdecode_base64_popup = "gb";
          encode_base64_inplace = "gB";
          vencode_base64_inplace = "gB";
          decode_base64url_inplace = "gys";
          vdecode_base64url_inplace = "gys";
          decode_base64url_popup = "gs";
          vdecode_base64url_popup = "gs";
          encode_base64url_inplace = "gS";
          vencode_base64url_inplace = "gS";
          decode_url_inplace = "gyl";
          vdecode_url_inplace = "gyl";
          decode_url_popup = "gl";
          vdecode_url_popup = "gl";
          encode_url_inplace = "gL";
          vencode_url_inplace = "gL";
        };
        popup = {
          enter = true;
          show_title = true;
          border = "rounded";
          transparency = 10;
          width = {
            min = 10;
            max = 80;
          };
          height = {
            min = 1;
            max = 50;
          };
          close_on = [
            "<Esc>"
            "q"
          ];
        };
      };
    };
  };
}
