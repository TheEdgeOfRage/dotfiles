return {
	-- Look and feel
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = true,
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
	},
	"nvim-lualine/lualine.nvim",

	-- keymaps
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	"folke/which-key.nvim",

	-- functionality
	"andymass/vim-matchup",
	"tpope/vim-repeat",
	"mbbill/undotree",
	{
		"nvim-zh/whitespace.nvim",
		config = function()
			vim.api.nvim_create_autocmd({ "BufWritePre", nil }, {
				callback = function()
					vim.cmd(":StripTrailingWhitespace")
				end,
			})
		end,
	},
	"lambdalisue/suda.vim",
	"xiyaowong/nvim-cursorword",
	{
		"Zeioth/project.nvim",
		config = function()
			require("project_nvim").setup({
				ignore_lsp = { "efm" },
			})
		end,
	},
	"alker0/chezmoi.vim",
	"mfussenegger/nvim-dap",
	"rcarriga/nvim-dap-ui",
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				default_options = {
					RGB = true,
					RRGGBB = true,
					RRGGBBAA = true,
					names = false,
				},
			})
		end,
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			toggler = {
				---Line-comment toggle keymap
				line = "<leader>/",
				---Block-comment toggle keymap
				block = "<leader>b/",
			},
			opleader = {
				---Line-comment keymap
				line = "<leader>/",
				---Block-comment keymap
				block = "<leader>b/",
			},
		},
		lazy = false,
	},

	-- Git
	"lewis6991/gitsigns.nvim",
	"sindrets/diffview.nvim",
	"tpope/vim-fugitive",
}
