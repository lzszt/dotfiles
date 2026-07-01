{
  system = "x86_64-linux";
  users = {
    leitz.user = "default";
    ag.user = "work";
  };
  default = {
    layout = "eu";
    user = "leitz";
  };

  polybar = {
    ethernet = [ "enp34s0" ];
    wifi = "wlo1";
  };
}
