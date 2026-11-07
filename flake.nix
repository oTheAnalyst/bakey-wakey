{
  description = "a basic flake for data analysis";

  inputs = {
    rnvim.url = "github:R-nvim/R.nvim";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    wrappers.url = "github:nix-community/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      wrappers,
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

            packages =
              with pkgs;
              [
                direnv
                nix-your-shell
                nixpkgs-fmt
                lazygit
                ncurses
                ripgrep
                git
                gradle
                fzf
              ]
              ++ (with self.packages.${system}; [
                starship
                fish
              ]);


            shellHook =
              #bash
              ''
                PARENT_PROCESS=$(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm)
                if [[ # Only exec fish if:
                  $PARENT_PROCESS != ${self.packages.x86_64-linux.fish} && # The parent process isn't already fish
                  -z ''${BASH_EXECUTION_STRING} # Bash wasn't started in script mode (BASH_EXECUTION_STRING is empty)
                ]]; then
                  shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
g                  exec ${lib.getExe self.packages.x86_64-linux.fish} $LOGIN_OPTION

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
          fish = wrappers.lib.evalPackage (
            { wlib, ... }: {
              inherit pkgs;
              imports = [ wlib.wrapperModules.fish ];
              shellAliases = {
                nvf = "nix run github:oTheAnalyst/bakey-wakey#nvf_raf";
                tts = "echo hello";
              };
              configFile.content = "eval (zellij setup --generate-auto-start fish | string collect) \n
                                                                starship init fish | source";

            }
          );

          starship = wrappers.lib.evalPackage (
            {
              wlib,
              ...
            }:
            {
              inherit pkgs;
              imports = [ wlib.wrapperModules.starship ];
              settings = {

                "$schema" = "https://starship.rs/config-schema.json";

                format = "$username$hostname$directory$gcloud$aws$git_branch$git_state$git_status$cmd_duration\n$python$character";
                right_format = "$nix_shell";

                directory = {
                  style = "blue";
                };

                character = {
                  success_symbol = "[❯](purple)";
                  error_symbol = "[❯](red)";
                  vimcmd_symbol = "[❮](green)";
                };

                git_branch = {
                  format = "[$branch]($style)";
                };

                git_status = {
                  format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
                  style = "cyan";
                  conflicted = "​";
                  untracked = "​";
                  modified = "​";
                  staged = "​";
                  renamed = "​";
                  deleted = "​";
                  stashed = "≡";
                };

                git_state = {
                  format = "\([$state( $progress_current/$progress_total)]($style)\) ";
                  style = "bright-black";
                };

                cmd_duration = {
                  format = "[$duration]($style) ";
                  style = "yellow";
                };

                python = {
                  format = "[$virtualenv]($style) ";
                  style = "bright-black";
                  detect_extensions = [ ];
                  detect_files = [ ];
                };

                glcoud = {
                  symbol = " ";
                };

                aws = {

                  symbol = "  ";
                };

                nix_shell = {
                  format = "[$symbol]($style) ";
                  symbol = " ";
                };
              };
            }
          );
          nvf_raf =
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
