{
  users = { leitz.userDefDir = "work"; };
  default = {
    layout = "us";
    user = "leitz";
  };
  polybar = {
    withBattery = true;
    ethernet = "enp0s13f0u2c2";
    wifi = "wlp170s0";
  };
}
