{
  description = "a basic flake for data analysis";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    rnvim.url = "github:R-nvim/R.nvim";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-parts,
    nvf,
    rnvim,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
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
