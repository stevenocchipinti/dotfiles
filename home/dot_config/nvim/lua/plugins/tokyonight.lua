return {
  "folke/tokyonight.nvim",
  opts = {
    style = "storm",
    transparent = true,
    on_highlights = function(hl, c)
      hl.WinSeparator = { fg = c.fg_gutter }
      hl.TabLineFill = { bg = c.black }
      hl.LineNr = { fg = c.dark3, bg = c.black }
      hl.CursorLineNr = { bg = c.black, fg = c.orange }
      hl.Folded = { bg = c.black }
      hl.DiagnosticUnnecessary = {}
    end,
  },
}
