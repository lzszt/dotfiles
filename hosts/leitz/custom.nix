{
  users = { leitz.userDefDir = "work"; };
  default = {
    layout = "us";
    user = "leitz";
  };
  polybar = {
    battery = "BAT1";
    ethernet = [ "enp0s20f0u3c2" "enp0s13f0u1u4" ];
    wifi = "wlp170s0";
  };
}
