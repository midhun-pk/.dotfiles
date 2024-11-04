-- Standalone plugins with less than 10 lines of config go here
return {
  {
    -- tmux & split window navigation
    'christoomey/vim-tmux-navigator',
  },
  {
    -- autoclose tags
    'windwp/nvim-ts-autotag',
  },
  {
    -- auto surround tags
    'tpope/vim-surround',
  },
  {
    -- detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
  },
  {
    -- Powerful Git integration for Vim
    'tpope/vim-fugitive',
  },
  {
    -- GitHub integration for vim-fugitive
    'tpope/vim-rhubarb',
  },
  {
    -- Hints keybinds
    'folke/which-key.nvim',
    opts = {
      -- win = {
      --   border = {
      --     { '┌', 'FloatBorder' },
      --     { '─', 'FloatBorder' },
      --     { '┐', 'FloatBorder' },
      --     { '│', 'FloatBorder' },
      --     { '┘', 'FloatBorder' },
      --     { '─', 'FloatBorder' },
      --     { '└', 'FloatBorder' },
      --     { '│', 'FloatBorder' },
      --   },
      -- },
    },
  },
  {
    -- Autoclose parentheses, brackets, quotes, etc.
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {},
  },
  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    -- high-performance color highlighter
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    -- Rename variables
    'smjonas/inc-rename.nvim',
    dependencies = {
      'stevearc/dressing.nvim',
    },
    config = function()
      require('inc_rename').setup({
        input_buffer_type = 'dressing',
      })
    end,
  },
  {
    -- render markdown
    'MeanderingProgrammer/markdown.nvim',
    main = "render-markdown",
    opts = {},
    name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you use the mini.nvim suite
  },
  {
    -- preview markdown in browser
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.opt.rtp:prepend(vim.fn.stdpath('data') .. '/lazy/markdown-preview.nvim')
      vim.fn["mkdp#util#install"]()
    end,
  },
}
