vim.g.mapleader = " "


-- Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
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

require("lazy").setup("plugins", {
    change_detection = {
        enabled = true,
        notify = false,
    },
})

vim.cmd([[colorscheme gruvbox]])

-- Import additional config files
require("sets")
require("mappings")
require("git")
require("lsp")
require("line")

require('telescope').load_extension('projects')
require('project_nvim').setup({})
