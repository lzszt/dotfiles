{
  system = "x86_64-linux";
  users = {
    leitz.userDefDir = "work";
    home.userDefDir = "minimal";
  };
  default = {
    layout = "eu";
    user = "leitz";
  };
  polybar = {
    battery = "BAT1";
    ethernet =
      [ "enp0s13f0u2c2" "enp0s13f0u1u4" "enp0s20f0u2u1u4" "enp0s13f0u2" ];
    wifi = "wlp170s0";
  };
}
