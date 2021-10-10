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
          buildInputs = with pkgs; [ hugo lessc rake feh ion inotify-tools ];
        };

        # nix run
        defaultApp = self.apps.${system}.server;

        # nix run ".#server"
        apps.server = pkgs.writers.writeBashBin "server" ''
          set -e
          set -o pipefail
          PATH=${
            pkgs.lib.makeBinPath [ pkgs.lessc pkgs.rake pkgs.ion pkgs.hugo ]
          }
          rake run_server
        '';

        # nix run ".#publish"
        apps.publish = pkgs.writers.writeBashBin "publish" ''
          set -e
          set -o pipefail
          PATH=${
            pkgs.lib.makeBinPath [ pkgs.lessc pkgs.rake pkgs.ion pkgs.hugo pkgs.rsync pkgs.openssh ]
          }
          rake publish
        '';

      }));
}
