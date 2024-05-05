{
  system = "x86_64-linux";
  users = { leitz.userDefDir = "minimal"; };
  default = {
    layout = "de";
    user = "leitz";
  };
  polybar = {
    battery = "BAT0";
    wifi = "wlp1s0";
  };
}
