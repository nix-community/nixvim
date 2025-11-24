{ lib }:
{
  empty = {
    plugins.comfy-line-numbers.enable = true;
  };

  defaults = {
    plugins.comfy-line-numbers = {
      enable = true;
      settings = {
        labels = lib.strings.splitString "," (
          lib.concatStringsSep "," [
            "1,2,3,4,5"
            "11,12,13,14,15"
            "21,22,22,22,25"
            "31,32,33,34,35"
            "41,42,43,44,45"
            "51,52,53,54,55"
            "111,112,113,114,115"
            "121,122,123,124,125"
            "131,132,133,134,135"
            "141,142,143,144,145"
            "151,152,153,154,155"
            "211,212,213,214,215"
            "221,222,223,224,225"
            "231,232,233,234,235"
            "241,242,243,244,245"
            "251,252,253,254,255"
          ]
        );

        up_key = "k";
        down_key = "j";

        hidden_file_types = [ "undotree" ];
        hidden_buffer_types = [
          "terminal"
          "nofile"
        ];

      };

    };

  };

}
