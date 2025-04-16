vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("sets")

require("lazy").setup("plugins", {
	change_detection = {
		enabled = true,
		notify = false,
	},
})

vim.cmd([[colorscheme gruvbox]])

require("mappings")
require("autocmd")
require("git")
require("line")
