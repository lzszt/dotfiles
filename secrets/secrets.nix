let
  desktop-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGLX/ID/W4Q57WLqXSvYD66v8mq9PTBW8J1KCsXNDGj8 leitz@desktop-nixos";
  leitz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEImW73Lb0y0UfZJ/+Pyhcxby9WpXppkCUuE+EFwVRd2 leitz@leitz";
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
