
-- File type with Nerd Font icon
local function file_type()
	local ft = vim.bo.filetype
	local icons = {
		lua = "\u{e620} ", -- nf-dev-lua
		python = "\u{e73c} ", -- nf-dev-python
		javascript = "\u{e74e} ", -- nf-dev-javascript
		typescript = "\u{e628} ", -- nf-dev-typescript
		javascriptreact = "\u{e7ba} ",
		typescriptreact = "\u{e7ba} ",
		html = "\u{e736} ", -- nf-dev-html5
		css = "\u{e749} ", -- nf-dev-css3
		scss = "\u{e749} ",
		json = "\u{e60b} ", -- nf-dev-json
		markdown = "\u{e73e} ", -- nf-dev-markdown
		vim = "\u{e62b} ", -- nf-dev-vim
		sh = "\u{f489} ", -- nf-oct-terminal
		bash = "\u{f489} ",
		zsh = "\u{f489} ",
		rust = "\u{e7a8} ", -- nf-dev-rust
		go = "\u{e724} ", -- nf-dev-go
		c = "\u{e61e} ", -- nf-dev-c
		cpp = "\u{e61d} ", -- nf-dev-cplusplus
		java = "\u{e738} ", -- nf-dev-java
		php = "\u{e73d} ", -- nf-dev-php
		ruby = "\u{e739} ", -- nf-dev-ruby
		swift = "\u{e755} ", -- nf-dev-swift
		kotlin = "\u{e634} ",
		dart = "\u{e798} ",
		elixir = "\u{e62d} ",
		haskell = "\u{e777} ",
		sql = "\u{e706} ",
		yaml = "\u{f481} ",
		toml = "\u{e615} ",
		xml = "\u{f05c} ",
		dockerfile = "\u{f308} ", -- nf-linux-docker
		gitcommit = "\u{f418} ", -- nf-oct-git_commit
		gitconfig = "\u{f1d3} ", -- nf-fa-git
		vue = "\u{fd42} ", -- nf-md-vuejs
		svelte = "\u{e697} ",
		astro = "\u{e628} ",
	}

	if ft == "" then
		return " \u{f15b} " -- nf-fa-file_o
	end

	return ((icons[ft] or " \u{f15b} ") .. ft)
end

-- Mode indicators with Nerd Font icons
local function mode_icon()
	local mode = vim.fn.mode()
	local modes = {
		n = " \u{f121}  NORMAL",
		i = " \u{f11c}  INSERT",
		v = " \u{f0168} VISUAL",
		V = " \u{f0168} V-LINE",
		["\22"] = " \u{f0168} V-BLOCK",
		c = " \u{f120} COMMAND",
		s = " \u{f0c5} SELECT",
		S = " \u{f0c5} S-LINE",
		["\19"] = " \u{f0c5} S-BLOCK",
		R = " \u{f044} REPLACE",
		r = " \u{f044} REPLACE",
		["!"] = " \u{f489} SHELL",
		t = " \u{f120} TERMINAL",
	}
	return modes[mode] or (" \u{f059} " .. mode)
end

local function diagnostic_count()
  local e = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local w = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local h = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  local i = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

  local result = {}

  if e > 0 then
    table.insert(result, "%#DiagnosticError# " .. e .. "%*")
  end
  if w > 0 then
    table.insert(result, "%#DiagnosticWarn# " .. w .. "%*")
  end
  if i > 0 then
    table.insert(result, "%#DiagnosticInfo# " .. i .. "%*")
  end
  if h > 0 then
    table.insert(result, "%#DiagnosticHint#󰌵 " .. h .. "%*")
  end

  local output = table.concat(result, " ")

  -- Add pipe only if there is any diagnostic
  if output ~= "" then
    return output .. " %#StatusLineDivider#|"
  end

  return ""
end

_G.mode_icon = mode_icon
_G.file_type = file_type
_G.diagnostic_count = diagnostic_count

vim.cmd([[
  highlight StatusLineBold gui=bold cterm=bold
]])

vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#ff6c6b" })
vim.api.nvim_set_hl(0, "DiagnosticWarn",  { fg = "#ECBE7B" })
vim.api.nvim_set_hl(0, "DiagnosticInfo",  { fg = "#51afef" })
vim.api.nvim_set_hl(0, "DiagnosticHint",  { fg = "#98be65" })
vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })
vim.api.nvim_set_hl(0, "StatusLineMode",  { fg = "#7AA2F7" })
vim.api.nvim_set_hl(0, "StatusLineFileName",  { fg = "#C3E88D" })
vim.api.nvim_set_hl(0, "StatusLineFileType",  { fg = "#FF9E64" })
vim.api.nvim_set_hl(0, "StatusLineDivider",  { fg = "#3B4261" })
vim.api.nvim_set_hl(0, "StatusLineColumnNumber",  { fg = "#EBCB8B" })
vim.api.nvim_set_hl(0, "StatusLineProgressPercentage",  { fg = "#B48EAD" })

-- Function to change statusline based on window focus
local function setup_dynamic_statusline()
	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "TermOpen" }, {
		callback = function()
      vim.schedule(function()
        vim.opt_local.statusline = table.concat({
          " ",
          "%#StatusLineBold#%#StatusLineMode#%{v:lua.mode_icon()} %#StatusLine#",
          "%#StatusLineDivider#| ",
          "%#StatusLineFileName#%t %h%m%r",
          "%=", -- Right-align everything after this
          "%{%v:lua.diagnostic_count()%} ",
          "%#StatusLineFileType#%{v:lua.file_type()} ",
          "%#StatusLineDivider#| ",
          "%#StatusLineColumnNumber#Ln %l:%c ",
          "%#StatusLineDivider#| ",
          "%#StatusLineProgressPercentage#%P ", -- nf-fa-clock_o for line/col
        })
      end)
		end,
	})

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		callback = function()
			vim.opt_local.statusline = "  %t %h%m%r \u{e0b1} %{v:lua.file_type()} %=  %l:%c   %P "
		end,
	})
end

setup_dynamic_statusline()

