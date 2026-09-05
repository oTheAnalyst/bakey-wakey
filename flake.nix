{
  description = "a basic flake for data analysis";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "github:nix-community/home-manager";
    rnvim.url = "github:R-nvim/R.nvim";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-parts,
    home-manager,
    nvf,
    nixpkgs,
    rnvim,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [inputs.home-manager.flakeModules.home-manager];
      systems = ["x86_64-linux"];
      flake = {
        # Reusable Home Manager module.
        homeModules.bash = {pkgs, ...}: {
          programs.bash = {
            enable = true;
            shellAliases = {
              ll = "ls -l";
            };
          };
          home.packages = [pkgs.hello];
        };

        # Concrete Home Manager configuration.
        homeConfigurations.alice = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {system = "x86_64-linux";};
          modules = [
            {
            }
          ];
        };
      };
      perSystem = {
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        devShells.default = import ./modules/shell.nix {inherit pkgs;};

        packages.default =
          (nvf.lib.neovimConfiguration {
            extraSpecialArgs = {
              inherit rnvim;
            };
            inherit pkgs;
            modules = [./modules/nvf.nix];
          }).neovim;
      };
    };
}
