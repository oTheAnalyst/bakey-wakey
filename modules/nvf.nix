{
  pkgs,
  rnvim,
  ...
}: {
  config = {
    # Your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    vim = let
      dataform-nvim-pkg = {
        vimUtils,
        fetchFromGitHub,
      }:
        vimUtils.buildVimPlugin {
          pname = "dataform-nvim";
          version = "0-unstable-2025-06-16";

          src = fetchFromGitHub {
            owner = "magal1337";
            repo = "dataform.nvim";
            rev = "43a5f9e17275325ae32e5248c6f21636418e2018";
            hash = "sha256-HA6E9L6U37Btb/dDgtm7du97/fae5IawCSg/nmB/tqg=";
          };

          meta = {
            description = "Dataform Core Plugin for Neovim";
            homepage = "https://github.com/magal1337/dataform.nvim";
            license = pkgs.lib.licenses.mit;
            #maintainers = with pkgs.lib.maintainers; [];
          };
        };
      dataform-nvim = pkgs.callPackage dataform-nvim-pkg {};
    in {
      autopairs.nvim-autopairs.enable = true;
      treesitter.context.enable = true;
      treesitter.enable = true;
      ui.noice.enable = false;
      binds.whichKey.enable = true;
      telescope.enable = true;
      startPlugins = with pkgs.vimPlugins; [
        rnvim.packages.${pkgs.stdenv.hostPlatform.system}.default
        vim-pencil
        dataform-nvim
        twilight-nvim
        barbar-nvim
        zen-mode-nvim
        render-markdown-nvim
      ];

      viAlias = false;
      vimAlias = true;
      theme = {
        enable = true;
        name = "tokyonight";
        style = "night";
      };

      utility = {icon-picker.enable = true;};

      visuals = {
        nvim-scrollbar.enable = true;
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;
        cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;
        highlight-undo.enable = true;
        blink-indent.enable = true;
        indent-blankline.enable = true;

        # Fun
        cellular-automaton.enable = false;
      };

      languages = {
        enableTreesitter = true;
      };

      languages.sql = {
        enable = true;
        format.enable = true;
      };

      languages.lua = {
        enable = true;
        extraDiagnostics.enable = true;
        extraDiagnostics.types = ["luacheck"];
        format.enable = true;
      };

      languages.nix = {
        enable = true;
        extraDiagnostics.enable = true;
        lsp.servers = ["nixd"];
        format.enable = true;
      };

      languages.python = {
        enable = true;
        dap.enable = true;
        format.enable = true;
      };

      languages.r = {
        enable = true;
        format.enable = true;
        treesitter.enable = true;
      };

      statusline.lualine.enable = true;
      autocomplete = {
        blink-cmp.enable = true;
      };

      lsp = {
        enable = true;
        formatOnSave = true;
        lightbulb.enable = true;
        trouble.enable = true;
      };
    };
  };
}
