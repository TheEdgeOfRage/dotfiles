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
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	"folke/which-key.nvim",

	-- functionality
	"andymass/vim-matchup",
	"tpope/vim-repeat",
	"tpope/vim-speeddating",
	"mbbill/undotree",
	"jdhao/whitespace.nvim",
	"lambdalisue/suda.vim",
	"xiyaowong/nvim-cursorword",
	"ahmedkhalf/project.nvim",
	"alker0/chezmoi.vim",
	-- {
	-- 	"github/copilot.vim",
	-- 	config = function()
	-- 		vim.g.copilot_filetypes = {
	-- 			["*"] = true,
	-- 			["markdown"] = true,
	-- 		}
	-- 	end,
	-- },
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
		"folke/neodev.nvim",
		dependencies = {
			"rcarriga/nvim-dap-ui",
		},
		opts = {
			library = {
				plugins = {
					"nvim-dap-ui",
				},
				types = true,
			},
		},
	},
}
