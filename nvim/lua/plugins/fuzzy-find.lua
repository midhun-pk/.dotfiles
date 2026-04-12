vim.pack.add({
  { src = "https://www.github.com/ibhagwan/fzf-lua" },
})

local setup_fzf_lua = function()
  require("fzf-lua").setup({
    fzf_opts = {
      ['--cycle'] = '',
    },
    files = {
      cwd_prompt = false,
    },
    winopts = {
      on_create = function()
        vim.schedule(function()
          vim.opt_local.statusline = ""
          vim.opt_local.winbar = ""
        end)
      end,
    },
  })

  vim.keymap.set("n", "<leader>sf", function()
    require("fzf-lua").files()
  end, { desc = "FZF Files" })
  vim.keymap.set("n", "<leader>sg", function()
    require("fzf-lua").live_grep()
  end, { desc = "FZF Live Grep" })
  vim.keymap.set("n", "<leader>sb", function()
    require("fzf-lua").buffers()
  end, { desc = "FZF Buffers" })
  vim.keymap.set("n", "<leader>sh", function()
    require("fzf-lua").help_tags()
  end, { desc = "FZF Help Tags" })
  vim.keymap.set("n", "<leader>sx", function()
    require("fzf-lua").diagnostics_document()
  end, { desc = "FZF Diagnostics Document" })
  vim.keymap.set("n", "<leader>sX", function()
    require("fzf-lua").diagnostics_workspace()
  end, { desc = "FZF Diagnostics Workspace" })
end

setup_fzf_lua()
