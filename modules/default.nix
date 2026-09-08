{pkgs ? import <nixpkgs> {}, ...}:
with pkgs;
  mkShell {
    packages = [
      (symlinkJoin {
        name = "starship-bakey";
        paths = [starship];
        nativeBuildInputs = [makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/starship \
              --set STARSHIP_CONFIG "${toString ./config/starship.toml}"
        '';
      })
      nixpkgs-fmt
      lsd
      tree
      ncurses
      ripgrep
      git
      bat
      gradle
      fish
      duckdb
      fzf
    ];
  }
