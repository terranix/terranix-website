{
  description = "terranix-website";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.terranix-examples.url = "github:terranix/terranix-examples";

  outputs = { self, nixpkgs, flake-utils, terranix-examples }:
    (flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {

        # nix develop
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ hugo lessc rake go-task feh ion inotify-tools ];
        };

        # nix run
        apps.default = self.apps.${system}.server;

        # nix run ".#server"
        apps.server = {
          type = "app";
          program = toString (pkgs.writers.writeBash "server" ''
            set -e
            set -o pipefail
            PATH=${
              pkgs.lib.makeBinPath [ pkgs.lessc pkgs.go-task pkgs.ion pkgs.hugo ]
            }
            task server
          '');
        };

        # nix run ".#publish"
        apps.publish = {
          type = "app";
          program = toString (pkgs.writers.writeBash "publish" ''
            set -e
            set -o pipefail
            PATH=${
              pkgs.lib.makeBinPath [ pkgs.lessc pkgs.go-task pkgs.ion pkgs.hugo pkgs.rsync pkgs.openssh ]
            }
            task publish
          ''
          );
        };

      }));
}
