---
title: Getting Started
draft: false
order: 10
summary: |
    You know nix and terraform and want to see how to terranix
    works? This the place to start.
letter: g
feature:
- /documentation/what-is-terranix.md
- /documentation/terranix-vs-hcl.md
- /documentation/modules.md
---

Let's have a quick overview on how you would use terranix.

If you search for working examples have a look at the
[examples folder at github](https://github.com/terranix/terranix-examples).

{{% note %}}
If you don't know what [NixOS](https://nixos.org) or
[Terraform](https://terraform.io) is, have a look at [what terranix is]({{< relref "what-is-terranix.md" >}}).
{{% /note %}}


## How to Set up

A convenient way is to create a shell.nix
which holds you terranix and terraform setup.

```nix
{ pkgs ? import <nixpkgs> { } }:
let
  hcloud_api_token = "`${pkgs.pass}/bin/pass development/hetzner.com/api-token`";
  
  terraform = pkgs.writers.writeBashBin "terraform" ''
    export TF_VAR_hcloud_api_token=${hcloud_api_token}
    ${pkgs.terraform_0_15}/bin/terraform "$@"
  '';

in pkgs.mkShell {
  buildInputs = [ pkgs.terranix terraform ];
}
```

### config.nix 

create a `config.nix` for example

```nix
{ ... }:
{
  resource.hcloud_server.nginx = {
    name = "terranix.nginx";
    image  = "debian-10";
    server_type = "cx11";
    backups = false;
  };
  resource.hcloud_server.test = {
    name = "terranix.test";
    image  = "debian-9";
    server_type = "cx11";
    backups = true;
  };
}
```

### Create a Server

Next lets generate a json file in terraform json format
and run terraform apply
to let terraform do it's magic.

```shell
terranix > config.tf.json && terraform init && terraform apply
```

### Destroy a Server

cleaning everything up is the job of terraform, just run : 

```shell
terraform destroy
```
