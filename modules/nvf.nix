{pkgs, ...}: {
  config = {
    # Your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    vim = {
      autopairs.nvim-autopairs.enable = true;
      ui.noice.enable = true;
      binds.whichKey.enable = true;
      telescope.enable = true;
      startPlugins = with pkgs;
      with vimPlugins; [
        vim-pencil
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
        enableLSP = true;
        enableTreesitter = true;
      };

      languages.sql = {
        enable = true;
        format.enable = true;
        lsp.enable = true;
        treesitter.enable = true;
      };

      languages.lua = {
        enable = true;
        extraDiagnostics.enable = true;
        extraDiagnostics.types = ["luacheck"];
        format.enable = true;
        lsp.enable = true;
      };

      languages.nix = {
        enable = true;
        extraDiagnostics.enable = true;
        lsp.servers = ["nil" "nixd"];
        format.enable = true;
        lsp.enable = true;
        treesitter.enable = true;
      };

      languages.python = {
        enable = true;
        dap.enable = true;
        format.enable = true;
        lsp.enable = true;
        treesitter.enable = true;
      };

      statusline.lualine.enable = true;
      autocomplete = {
        nvim-cmp.enable = true;
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
