{
  description = "a basic flake for data analysis";

  inputs = {
    # In your flake.nix
    rnvim.url = "github:R-nvim/R.nvim";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    wrappers.url = "github:lassulus/wrappers";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nvf,
      rnvim,
      nixpkgs,
      ...
    }:
    let
      forEachPkgs =
        f:
        lib.mapAttrs (
          system: pkgs:
          f (import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          }) system
        ) nixpkgs.legacyPackages;
      inherit (nixpkgs) lib;
    in
    {
      devShells = forEachPkgs (
        pkgs: system: {
          default = pkgs.mkShell {
            packages = with pkgs; [
              starship
              direnv
              nix-your-shell
              nixpkgs-fmt
              lazygit
              ncurses
              ripgrep
              git
              gradle
              fish
              fzf
            ];
            shellHook =
              #bash
              ''
                PARENT_PROCESS=$(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm)
                if [[ # Only exec fish if:
                  $PARENT_PROCESS != "fish" && # The parent process isn't already fish
                  -z ''${BASH_EXECUTION_STRING} # Bash wasn't started in script mode (BASH_EXECUTION_STRING is empty)
                ]]; then
                  shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
                  exec ${lib.getExe pkgs.fish} $LOGIN_OPTION
                fi
              '';
          };
          extra-utilz = pkgs.mkShell {
            packages = with pkgs; [
              (writeShellScriptBin "y" ''exec yazi "$@" '')
              yazi
              tree
              duckdb
              zellij
              bat
              lsd
            ];
          };
          full-shell = pkgs.mkShell {
            inputsFrom = with self.devShells.${system}; [
              default
              extra-utilz
            ];
          };
        }
      );
      packages = forEachPkgs (
        pkgs: system: {

          default =
            (nvf.lib.neovimConfiguration {
              extraSpecialArgs = {
                inherit rnvim;
              };
              inherit pkgs;
              modules = [ ./modules/nvf.nix ];
            }).neovim;
        }
      );
    };
}
