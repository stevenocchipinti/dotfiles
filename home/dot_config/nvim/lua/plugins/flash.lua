return {
  {
    "folke/flash.nvim",
    opts = {},
    keys = {
      -- replace the default flash keymap with a localleader mapping
      { "s", mode = { "n", "x", "o" }, false },
      {
        "<localleader>s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },

      -- This should be default anyway, but it doesn't quite work like the
      -- original treesitter incremental selection :(
      {
        "<c-space>",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter({
            actions = {
              ["<c-space>"] = "next",
              ["<BS>"] = "prev",
            },
          })
        end,
        desc = "Treesitter Incremental Selection",
      },
    },
  },
}
