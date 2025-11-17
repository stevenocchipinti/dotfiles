return {
  {
    "nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter",
    opts = {
      textobjects = {
        select = {
          enable = true,
          keymaps = {
            -- There are some custom text objects configured with mini.ai
            ["ac"] = "@comment.outer", -- These normally default to @class
            ["ic"] = "@comment.outer", -- @comment.inner not supported in TS/JS
            ["ak"] = "@assignment.lhs",
            ["ik"] = "@assignment.lhs",
            ["av"] = "@assignment.rhs",
            ["iv"] = "@assignment.rhs",
            ["ar"] = "@attribute.outer",
            ["ir"] = "@attribute.inner",
          },
        },
        move = {
          enable = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@comment.outer",
            ["]a"] = "@parameter.inner",
            ["]r"] = "@attribute.outer",
            ["]R"] = "@attribute.inner",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@comment.outer",
            ["[a"] = "@parameter.inner",
            ["[r"] = "@attribute.outer",
            ["[R"] = "@attribute.inner",
          },
        },
      },
    },
  },
  {
    "aaronik/treewalker.nvim",
    opts = {
      jumplist = false,
    },
    keys = {
      { "<M-h>", "<cmd>Treewalker Left<cr>", desc = "Treewalker Left" },
      { "<M-j>", "<cmd>Treewalker Down<cr>", desc = "Treewalker Down" },
      { "<M-k>", "<cmd>Treewalker Up<cr>", desc = "Treewalker Up" },
      { "<M-l>", "<cmd>Treewalker Right<cr>", desc = "Treewalker Right" },

      { "<M-H>", "<cmd>Treewalker SwapLeft<cr>", desc = "Treewalker Left" },
      { "<M-J>", "<cmd>Treewalker SwapDown<cr>", desc = "Treewalker Down" },
      { "<M-K>", "<cmd>Treewalker SwapUp<cr>", desc = "Treewalker Up" },
      { "<M-L>", "<cmd>Treewalker SwapRight<cr>", desc = "Treewalker Right" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "ac", mode = { "o", "x" }, desc = "comment" }, -- Not overriding class for some reason
        { "ic", mode = { "o", "x" }, desc = "comment" }, -- Not overriding class for some reason
        { "ak", mode = { "o", "x" }, desc = "assignment LHS (key)" },
        { "ik", mode = { "o", "x" }, desc = "assignment LHS (key)" },
        { "av", mode = { "o", "x" }, desc = "assignment RHS (value)" },
        { "iv", mode = { "o", "x" }, desc = "assignment RHS (value)" },
        { "ir", mode = { "o", "x" }, desc = "attribute (react, html, etc.)" },
      },
    },
  },
}
