return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			vim.treesitter.start()
			require("nvim-treesitter").install({
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
			})
		end,
	},
	"alker0/chezmoi.vim",
}
