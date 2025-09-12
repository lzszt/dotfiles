let
  desktop-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGLX/ID/W4Q57WLqXSvYD66v8mq9PTBW8J1KCsXNDGj8 leitz@desktop-nixos";
  leitz = "";
  netbook = "";
  all = [
    desktop-nixos
  ];
in
{
  "hetzner-storage-box-credentials.age".publicKeys = all;
}
