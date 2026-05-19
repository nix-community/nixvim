/**
  Fetches Nixvim's pinned revision of Nixpkgs without evaluating the flake.
*/
let
  # fetchTree was added in Nix 2.4 as an experimental feature, so provide a fetchTarball-based polyfill
  # Based on https://github.com/NixOS/flake-compat/blob/5edf11c4/default.nix#L20-L36
  fetchTree =
    builtins.fetchTree or (
      info:
      if info.type == "github" then
        {
          inherit (info) rev narHash lastModified;
          shortRev = builtins.substring 0 7 info.rev;
          lastModifiedDate = formatSecondsSinceEpoch info.lastModified;
          outPath = fetchTarball {
            url = "https://api.${info.host or "github.com"}/repos/${info.owner}/${info.repo}/tarball/${info.rev}";
            sha256 = info.narHash;
          };
        }
      else
        throw "fetchTree: unsupported type '${info.type}'"
    );

  # Format number of seconds since the Unix epoch as %Y%m%d%H%M%S.
  # Based on https://github.com/NixOS/flake-compat/blob/5edf11c4/default.nix#L172-L197
  # Uses Howard Hinnant civil date algorithm.
  formatSecondsSinceEpoch =
    let
      rem = x: y: x - x / y * y;
      pad = s: if builtins.stringLength s < 2 then "0" + s else s;

      second = 1;
      minute = 60 * second;
      hour = 60 * minute;
      day = 24 * hour;

      # Gregorian leap year rules:
      # - leap year every 4 years
      # - except every 100 years
      # - except every 400 years
      daysPerYear = 365;
      daysPer4Years = daysPerYear * 4 + 1;
      daysPer100Years = daysPerYear * 100 + 24;
      daysPer400Years = daysPerYear * 400 + 97;

      monthsToDaysDivisor = 153;
      monthsToDaysOffset = 2;

      # Days between civil date epoch 0000-03-01 and Unix epoch 1970-01-01.
      civilDayOffset = 719468;
    in
    t:
    let
      z = (t / day) + civilDayOffset;
      secondsInDay = rem t day;
      hours = secondsInDay / hour;
      minutes = (rem secondsInDay hour) / minute;
      seconds = rem t minute;

      # Gregorian calendars repeat every 400 years.
      era = (if z >= 0 then z else z - (daysPer400Years - 1)) / daysPer400Years;

      dayOfEra = z - era * daysPer400Years;

      yearOfEra =
        (
          dayOfEra - dayOfEra / daysPer4Years + dayOfEra / daysPer100Years - dayOfEra / (daysPer400Years - 1)
        )
        / daysPerYear;

      year' = yearOfEra + era * 400;
      dayOfYear = dayOfEra - (daysPerYear * yearOfEra + yearOfEra / 4 - yearOfEra / 100);
      month' = (5 * dayOfYear + monthsToDaysOffset) / monthsToDaysDivisor;
      dayOfMonth = dayOfYear - (monthsToDaysDivisor * month' + monthsToDaysOffset) / 5 + 1;

      # The algorithm uses March-indexed months, so offset back to January-index
      month = month' + (if month' < 10 then 3 else -9);
      year = year' + (if month <= 2 then 1 else 0);
    in
    toString year
    + pad (toString month)
    + pad (toString dayOfMonth)
    + pad (toString hours)
    + pad (toString minutes)
    + pad (toString seconds);

  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  node = lock.nodes.${lock.nodes.${lock.root}.inputs.nixpkgs};
in
assert !(node.locked ? dir);
fetchTree node.locked
