---
title: Getting Started with nix flake
draft: false
order: 11
summary: |
    You know nix flakes and terraform and want to see how to terranix
    works with nix flakes? This the place to start.
letter: g
---

You can check out this example using the `teamplate` feature of nix flakes.
```shell
nix flake init --template github:terranix/terranix
```
you get a list of all templates:
```shell
nix flake show github:terranix/terranix-examples
```

{{% note %}}
If you don't know what [NixOS](https://nixos.org) or
[Terraform](https://terraform.io) is, have a look at [what terranix is]({{< relref "what-is-terranix.md" >}}).
{{% /note %}}

## How to set up

nix flakes make dependency management of modules and packages much easier.

## `flake.nix`

First you need a `flake.nix`

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    terranix = {
      url = "github:terranix/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, terranix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        terraform = pkgs.terraform_0_15;
        
        terraformConfiguration = terranix.lib.buildTerranix {
          inherit pkgs;
          terranix_config.imports = [ ./config.nix ];
        };
      in {
        defaultPackage = terraformConfiguration;
        # nix develop
        devShell = pkgs.mkShell {
          buildInputs =
            [ pkgs.terraform_0_15 terranix.defaultPackage.${system} ];
        };
        # nix run ".#apply"
        apps.apply = {
          type = "app";
          program = toString (pkgs.writers.writeBash "apply" ''
            if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
            cp ${terraformConfiguration}/config.tf.json config.tf.json \
              && ${terraform}/bin/terraform init \
              && ${terraform}/bin/terraform apply
          '');
        };
        # nix run ".#destroy"
        apps.destroy = {
          type = "app";
          program = toString (pkgs.writers.writeBash "destroy" ''
            if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
            cp ${terraformConfiguration}/config.tf.json config.tf.json \
              && ${terraform}/bin/terraform init \
              && ${terraform}/bin/terraform destroy
          '');
        };
        # nix run
        defaultApp = self.apps.${system}.apply;
      });
}
```

This flake defines a bunch of things

* A package (`nix build`) containing the rendered `config.tf.json`.
* A development shell (`nix develop`) containing `terraform` and `terranix` command line tools
* Applications to apply (`nix ".#apply"`) and destroy (`nix ".#destroy"`) the defined configuration.

## `config.nix`

The terranix configuration is placed in `config.nix` because we 
import it using 
```nix
terranix_config.import = [ ./config.nix ];
```
You are able to import more than one file here,
or even inline terranix code.
This is usually the place to import external terranix modules which
managed as flake input.

## import terranix modules

terranix modules should also be available via nix flakes using the outputs

* `terranixModules.<name>`
* `terranixModule` : should contain all `terranixModules` combined of the given flake.

So they can be used like

```nix
inputs.github.url = "github:terranix/terranix-module-github";
...
terraformConfiguration = terranix.lib.buildTerranix {
  inherit pkgs;
  terranix_config.imports = [ 
    github.terranixModule
    ./config.nix 
  ];
};
```
