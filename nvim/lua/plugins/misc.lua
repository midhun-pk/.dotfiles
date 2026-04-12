
vim.pack.add({
  { src = "https://www.github.com/windwp/nvim-autopairs" },
  { src = "https://www.github.com/folke/todo-comments.nvim" },
  { src = "https://www.github.com/smjonas/inc-rename.nvim" },
})

require("nvim-autopairs").setup()
require("todo-comments").setup()
require("inc_rename").setup({})
