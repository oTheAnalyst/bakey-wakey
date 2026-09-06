{pkgs ? import <nixpkgs> {}, ...}:
with pkgs;
  mkShell {
    packages = [
      (writeShellScriptBin "y" ''exec yazi "$@" '')
      yazi
      zellij
      lazygit
      zathura
    ];
  }
