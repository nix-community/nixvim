{ name, lib, ... }:
{
  imports = [
    (lib.mkRenamedOptionModule [
      "plugin"
      "finalConfig"
    ])
  ];

  config = {
    target = lib.mkDefault name;
  };
}
