---
title: terranix.org
feature-header: get started with
feature:
  - documentation/what-is-terranix.md
  - documentation/getting-started.md
  - documentation/terranix-vs-hcl.md
---

A NixOS way to create
[terraform json](https://www.terraform.io/docs/configuration/syntax-json.html)
files.

## Features

* Using terranix is very similar to use terraform, you can use the
  [terraform reference material](https://www.terraform.io/docs/providers/index.html)
  without much hassle.
* The full power of the nix language (map, filter, reduce, ... )
* The full power of the module system of NixOS
* The full power of all the tooling in `pkgs` of NixOS (fetchgit,fetchurl,writers, ...)
* Documentation generation from `config.nix` as json or man page.
