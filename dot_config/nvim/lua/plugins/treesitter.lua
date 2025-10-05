return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile", "VeryLazy" },
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
				},
				modules = {},
				ignore_install = {},
				auto_install = true,
				sync_install = false,
				ensure_installed = {
					"bash",
					"go",
					"javascript",
					"json",
					"lua",
					"luadoc",
					"luap",
					"markdown",
					"markdown_inline",
					"python",
					"query",
					"regex",
					"terraform",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
					"yaml",
				},
			})
		end,
	},
	"alker0/chezmoi.vim",
}
