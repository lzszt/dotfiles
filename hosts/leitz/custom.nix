{
  users = { leitz.userDefDir = "work"; };
  default = {
    layout = "eu";
    user = "leitz";
  };
  polybar = {
    battery = "BAT1";
    ethernet = [ "enp0s13f0u2c2" "enp0s13f0u1u4" ];
    wifi = "wlp170s0";
  };
}
