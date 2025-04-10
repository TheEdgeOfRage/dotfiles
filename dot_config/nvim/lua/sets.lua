vim.opt.clipboard = "unnamedplus"
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.encoding = "utf8"
vim.opt.shell = "/bin/bash"
vim.opt.background = "dark"
vim.opt.laststatus = 2
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.textwidth = 120
vim.opt.colorcolumn = "+1"
vim.opt.listchars = "tab:│ ,trail:~,extends:>,precedes:<"

vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
local function get_custom_foldtxt_suffix(foldstart)
	local fold_suffix_str = string.format("  %s [%s lines]", "┉", vim.v.foldend - foldstart + 1)

	return { fold_suffix_str, "Folded" }
end

local function get_custom_foldtext(foldtxt_suffix, foldstart)
	local line = vim.api.nvim_buf_get_lines(0, foldstart - 1, foldstart, false)[1]

	return {
		{ line, "Normal" },
		foldtxt_suffix,
	}
end

_G.get_foldtext = function()
	local foldstart = vim.v.foldstart
	local ts_foldtxt = vim.treesitter.foldtext()
	local foldtxt_suffix = get_custom_foldtxt_suffix(foldstart)

	if type(ts_foldtxt) == "string" then
		return get_custom_foldtext(foldtxt_suffix, foldstart)
	else
		table.insert(ts_foldtxt, foldtxt_suffix)
		return ts_foldtxt
	end
end

vim.opt.foldtext = "v:lua.get_foldtext()"

vim.opt.termguicolors = true
vim.opt.autochdir = true
vim.opt.showcmd = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.list = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true
vim.opt.undodir = "/home/pavle/.local/share/nvim/undodir"
vim.opt.scrolloff = 8
vim.opt.mousescroll = "ver:1,hor:1"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.shell = "/usr/bin/zsh"

vim.diagnostic.config({ virtual_text = true })
