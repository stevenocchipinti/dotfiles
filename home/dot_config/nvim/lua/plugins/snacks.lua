return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>e", false }, -- Using mini.files as the default
  },
  opts = {
    explorer = {
      replace_netrw = false, -- Using mini.files as the default
    },
    words = {
      enabled = false, -- The colours of this clash when using autocomplete
    },
    zen = {
      on_open = function()
        vim.wo.number = false
        vim.wo.signcolumn = "no"
        vim.wo.statuscolumn = ""
        vim.wo.colorcolumn = ""
      end,
      on_close = function()
        vim.wo.number = true
        vim.wo.signcolumn = "yes"
        vim.wo.statuscolumn = "%!v:lua.require'snacks.statuscolumn'.get()"
        vim.wo.colorcolumn = "81"
      end,
    },
  },
}
