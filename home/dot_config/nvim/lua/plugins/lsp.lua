return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      diagnostics = {
        float = {
          border = "rounded",
        },
      },
      servers = {
        emmet_language_server = {},
      },
    },
  },
  { "dmmulroy/ts-error-translator.nvim", opts = {} },
  {
    "olrtg/nvim-emmet",
    config = function()
      vim.keymap.set(
        { "n", "v" },
        "<leader>xe",
        require("nvim-emmet").wrap_with_abbreviation
      )
    end,
  },
}
