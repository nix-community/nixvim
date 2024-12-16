[
  "envFile"
  "encodeUrl"
  "skipSslVerification"
  "customDynamicVariables"
  [
    "highlight"
    "timeout"
  ]
  {
    old = "resultSplitHorizontal";
    new = [
      "result"
      "split"
      "horizontal"
    ];
  }
  {
    old = "resultSplitInPlace";
    new = [
      "result"
      "split"
      "in_place"
    ];
  }
  {
    old = "stayInCurrentWindowAfterSplit";
    new = [
      "result"
      "split"
      "stay_in_current_window_after_split"
    ];
  }
  {
    old = [
      "result"
      "showUrl"
    ];
    new = [

      "result"
      "behavior"
      "show_info"
      "url"
    ];
  }
  {
    old = [
      "result"
      "showHeaders"
    ];
    new = [

      "result"
      "behavior"
      "show_info"
      "headers"
    ];
  }
  {
    old = [
      "result"
      "showHttpInfo"
    ];
    new = [
      "result"
      "behavior"
      "show_info"
      "http_info"
    ];
  }
  {
    old = [
      "result"
      "showCurlCommand"
    ];
    new = [
      "result"
      "behavior"
      "show_info"
      "curl_command"
    ];
  }
  {
    old = [
      "result"
      "formatters"
    ];
    new = [
      "result"
      "behavior"
      "formatters"
    ];
  }
  {
    old = [
      "highlight"
      "enabled"
    ];
    new = [
      "highlight"
      "enable"
    ];
  }
]
