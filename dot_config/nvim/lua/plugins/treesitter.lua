return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			vim.api.nvim_create_autocmd("BufEnter", {
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},
	{
		"lewis6991/ts-install.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("ts-install").setup({
				auto_install = true,
				ensure_install = {
					"bash",
					"css",
					"go",
					"html",
					"javascript",
					"json",
					"lua",
					"luadoc",
					"luap",
					"markdown",
					"markdown_inline",
					"python",
					"regex",
					"rust",
					"templ",
					"typescript",
					"yaml",
				},
			})
		end,
	},
	"alker0/chezmoi.vim",
}
