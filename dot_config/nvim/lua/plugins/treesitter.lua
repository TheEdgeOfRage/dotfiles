return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		version = false,
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile", "VeryLazy" },
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		main = "nvim-treesitter",
		opts = {
			auto_install = true,
			ensure_installed = {
				"bash",
				"json",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"regex",
				"yaml",
			},
		},
	},
	"alker0/chezmoi.vim",
}
