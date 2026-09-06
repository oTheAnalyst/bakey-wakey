{pkgs ? import <nixpkgs> {}, ...}:
with pkgs;
  mkShell {
    packages = [
      zellij
      yazi
      ipfetch
      fastfetch
    ];
  }
