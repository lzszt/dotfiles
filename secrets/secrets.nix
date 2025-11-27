let
  desktop-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGLX/ID/W4Q57WLqXSvYD66v8mq9PTBW8J1KCsXNDGj8 leitz@desktop-nixos";
  leitz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG6o4SiFpsgaR5H7MH2slofck0Mn8rveACBMPqKi/N4k leitz@leitz";
  netbook = "";
  all = [
    desktop-nixos
    leitz
  ];
in
{
  "hetzner-storage-box-credentials.age".publicKeys = [ desktop-nixos ];
  "arbeitszeiten-api-key.age".publicKeys = [
    desktop-nixos
    leitz
  ];
  "abrechenbare-zeiten-api-key.age".publicKeys = [
    desktop-nixos
    leitz
  ];
  "nas-credentials.age".publicKeys = [ leitz ];
}
