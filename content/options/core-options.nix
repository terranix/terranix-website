{ pkgs, ... }:
let
  terranix = pkgs.fetchgit {
    url = "https://github.com/terranix/terranix.git";
    rev = "2.4.0";
    sha256 = "030067h3gjc02llaa7rx5iml0ikvw6szadm0nrss2sqzshsfimm4";
  };

in
{
  imports = [ "${terranix}/modules" "${terranix}/core/terraform-options.nix" ];
}
