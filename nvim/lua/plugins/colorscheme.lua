vim.pack.add({
	"https://www.github.com/rebelot/kanagawa.nvim",
})

require("kanagawa").setup({
  keywordStyle = { italic = false, bold = false },
  statementStyle = { italic = false, bold = false },
  typeStyle = { italic = false, bold = false },

  overrides = function(colors)
    return {
      LineNr = { bg = colors.theme.ui.bg },
      CursorLineNr = { bg = colors.theme.ui.bg },
      SignColumn = { bg = colors.theme.ui.bg },
      FoldColumn = { bg = colors.theme.ui.bg },
      Comment = { italic = false },
      NormalFloat = { bg = colors.theme.ui.bg },
      FloatBorder = { bg = colors.theme.ui.bg },
    }
  end,
})

vim.cmd.colorscheme("kanagawa")

local palette = require("kanagawa.colors").setup().palette

vim.api.nvim_set_hl(0, "Constant", {
  fg = palette.surimiOrange,
})

for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
  if ok and hl and hl.bold then
    hl.bold = false
    vim.api.nvim_set_hl(0, group, hl)
  end
end
