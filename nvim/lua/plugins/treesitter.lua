-- Additional requirement: Install tree-sitter-cli using homebrew or npm

vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
  },
})

local setup_treesitter = function()
  local ensureInstalled = {
    'lua',
    'python',
    'javascript',
    'typescript',
    'vimdoc',
    'vim',
    'regex',
    'terraform',
    'sql',
    'dockerfile',
    'toml',
    'json',
    'java',
    'groovy',
    'go',
    'gitignore',
    'graphql',
    'yaml',
    'make',
    'cmake',
    'markdown',
    'markdown_inline',
    'bash',
    'tsx',
    'css',
    'html',
    -- ... your parsers
  }

  -- Autoinstall languages that are not installed
  local alreadyInstalled = require('nvim-treesitter.config').get_installed()
  local parsersToInstall = vim.iter(ensureInstalled)
  :filter(function(parser)
    return not vim.tbl_contains(alreadyInstalled, parser)
  end)
  :totable()
  require('nvim-treesitter').install(parsersToInstall)

  vim.api.nvim_create_autocmd('FileType', {
    callback = function()
      -- Enable treesitter highlighting and disable regex syntax
      pcall(vim.treesitter.start)
      -- Enable treesitter-based indentation
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
end

setup_treesitter()
