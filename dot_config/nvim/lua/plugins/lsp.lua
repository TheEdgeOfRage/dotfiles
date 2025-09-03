return {
	{
		"williamboman/mason.nvim",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				automatic_installation = true,
				ensure_installed = {},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		config = function(_, _)
			local prettier = {
				formatCommand = 'prettierd "${INPUT}"',
				formatStdin = true,
				env = {
					string.format(
						"PRETTIERD_DEFAULT_CONFIG=%s",
						vim.fn.expand("~/.config/nvim/utils/linter-config/.prettierrc.json")
					),
				},
			}
			local efm_languages = {
				typescript = { prettier },
				javascript = { prettier },
				json = { prettier },
				markdown = { prettier },
			}
			local servers = {
				golangci_lint_ls = {},
				gopls = {
					settings = {
						gopls = {
							gofumpt = false,
							staticcheck = true,
							analyses = {
								ST1000 = false,
							},
							hints = {
								assignVariableTypes = false,
								compositeLiteralFields = false,
								compositeLiteralTypes = false,
								constantValues = false,
								functionTypeParameters = false,
								parameterNames = false,
								rangeVariableTypes = false,
							},
						},
					},
				},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							diagnostics = {
								enable = true,
							},
							cargo = {
								allFeatures = false,
							},
							imports = {
								granularity = {
									group = "module",
								},
								prefix = "self",
							},
							procMacro = {
								enable = true,
							},
						},
					},
				},
				basedpyright = {},
				ruff = {},
				efm = {
					cmd = { "/home/pavle/.local/share/nvim/mason/bin/efm-langserver" },
					init_options = { documentFormatting = true },
					filetypes = vim.tbl_keys(efm_languages),
					settings = {
						rootMarkers = { ".git/", ".prettierignore" },
						lintDebounce = 100,
						logLevel = 5,
						logFile = "/home/pavle/.local/state/nvim/efm.log",
						languages = efm_languages,
					},
					single_file_support = true,
				},
				eslint = {},
				ts_ls = {},
				prismals = {},
				graphql = {},
				-- gleam = {},
				buf_ls = {},
				lua_ls = {},
				terraformls = {},
				jsonls = {},
				yamlls = {},
				bashls = {},
				-- zls = {},
			}

			for server, config in pairs(servers) do
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				vim.lsp.enable(server)
				vim.lsp.config(server, config)
			end
		end,
	},
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = { "LazyVim" },
				},
			},
		},
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			fuzzy = { implementation = "prefer_rust_with_warning" },
			sources = {
				default = { "lazydev", "lsp", "snippets", "path" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
			keymap = {
				preset = "default",
				["<CR>"] = { "select_and_accept", "fallback" },
			},
			completion = {
				keyword = {
					-- 'prefix' will fuzzy match on the text before the cursor
					-- 'full' will fuzzy match on the text before _and_ after the cursor
					range = "full",
				},
				documentation = {
					auto_show = true,
				},
			},
			signature = { enabled = true },
		},
	},
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()',
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				format_on_save = {
					timeout_ms = 2000,
					lsp_format = "fallback",
				},
				formatters_by_ft = {
					lua = { "stylua" },
					markdown = { "markdownlint" },
					terraform = { "tflint" },
					json = { "jsonlint", "prettierd" },
					javascript = { "efm" },
					typescript = { "efm" },
					svelte = { "prettierd" },
					go = { "golines", "golangci-lint" },
					html = { "htmlbeautifier", "htmlhint" },
					tmpl = { "htmlbeautifier", "htmlhint" },
				},
			})
		end,
	},
}
