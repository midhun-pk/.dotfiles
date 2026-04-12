vim.pack.add({
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
})

vim.keymap.set("n", "<leader>w", ":Neotree toggle float<CR>", { silent = true, desc = "Float File Explorer" })
vim.keymap.set("n", "<leader>e", ":Neotree toggle position=left<CR>", { silent = true, desc = "Left File Explorer" })
vim.keymap.set("n", "<leader>fr", ":Neotree toggle reveal float<CR>", { silent = true, desc = "Reveal File" })
vim.keymap.set("n", "<leader>ngs", ":Neotree float git_status<CR>", { silent = true, desc = "Git Status" })

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = "󰋼 ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
    },
  },
})

require("neo-tree").setup({
  close_if_last_window = false,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,

  window = {
    position = "left",
    width = 40,
  },

  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
})
