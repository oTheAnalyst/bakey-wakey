{
  pkgs ? import <nixpkgs> {},
  wrappers,
  ...
}:
with pkgs;
  mkShell {
    buildInputs = [
      tree
      (sysmlinkJoin {
        name = "starship";
        buildInputs = [makeWrapper];
        path = [pkgs.starship];
        postBuild = ''
          wrapProgram $out/bin/starship \
              --append-flags "--configu ${../config/starship.toml}"
        '';
      })
      starship
      sqlfluff
      nixpkgs-fmt
      ncurses
      zellij
      google-cloud-sdk
      yazi
      ripgrep
      git
      bat
      lazygit
      fastfetch
      gradle
      fish
      duckdb
      fzf
    ];
  }
