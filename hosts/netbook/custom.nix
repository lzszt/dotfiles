{
  users = { leitz.userDefDir = "default"; };
  default = {
    layout = "de";
    user = "leitz";
  };
  polybar = {
    withBattery = true;
    ethernet = [ ];
    wifi = "wlp1s0";
  };
}
