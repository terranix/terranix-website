{ pkgs ?  import <nixpkgs> {} }:
pkgs.mkShell {

  # needed pkgs
  # -----------
  buildInputs = with pkgs; [
    hugo

    blockdiag
    nwdiag
    seqdiag
    actdiag

    lessc

    rake
    feh

    ion
    inotify-tools

    pandoc
  ];

  # run this on start
  # -----------------
  shellHook = ''
    export HELLO="world"
  '';
}
