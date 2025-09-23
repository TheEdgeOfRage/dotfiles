local opts = { noremap = true, silent = true }

-- Colemak bindings
vim.keymap.set("", "n", "j", opts)
vim.keymap.set("", "e", "k", opts)
vim.keymap.set("", "i", "l", opts)
vim.keymap.set("", "I", "$", opts)
vim.keymap.set("", "H", "^", opts)
vim.keymap.set("", "l", "i", opts)
vim.keymap.set("", "L", "I", opts)
vim.keymap.set("n", "N", "mzJ`z", opts)
vim.keymap.set("", "k", "n", opts)
vim.keymap.set("", "K", "N", opts)
vim.keymap.set("", "J", "M", opts)
vim.keymap.set("", "j", "m", opts)
vim.keymap.set("", "m", "e", opts)
vim.keymap.set("", "M", "E", opts)

vim.keymap.set("v", "N", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "E", ":m '<-2<CR>gv=gv", opts)

-- General mappings
vim.keymap.set("", "<BS>", "gg", opts)
vim.keymap.set("", "<CR>", "G", opts)
vim.keymap.set("", "<Space>", "<NOP>", opts)

vim.keymap.set("x", "p", "pgvy", opts)

vim.keymap.set("n", "<tab>", vim.cmd.bn, opts)
vim.keymap.set("n", "<s-tab>", vim.cmd.bp, opts)
vim.keymap.set("n", "U", vim.cmd.redo, opts)

-- File operation maps
vim.keymap.set("n", "<leader>fd", function()
	if vim.inspect(vim.lsp.get_clients()) then
		require("conform").format()
	else
		vim.cmd.normal("jzgg=G`z")
	end
end, opts)
vim.keymap.set("n", "<leader>fs", vim.cmd.w, opts)
vim.keymap.set("n", "<leader>fS", vim.cmd.SudaWrite, opts)
vim.keymap.set("n", "<leader>W", vim.cmd.SudaWrite, opts)
vim.keymap.set("n", "<leader>q", vim.cmd.q, opts)
vim.keymap.set("n", "<leader>Q", ":q!<cr>", opts)
vim.keymap.set("n", "<leader>wq", vim.cmd.wq, opts)
vim.keymap.set("n", "<leader>bd", ":bp | bd #<cr>", opts)
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, opts)
vim.keymap.set("", "\\", ':let @/ = ""<CR>', opts)
require("Comment.ft").set("resolv", "#%s")

-- Git
vim.keymap.set("n", "<leader>gd", vim.cmd.Gvdiff, opts)
vim.keymap.set("n", "<leader>gb", function()
	vim.cmd("Gitsigns toggle_current_line_blame")
end, opts)

-- window movement
vim.keymap.set("n", "<leader>wn", "<C-W>j", opts)
vim.keymap.set("n", "<leader>we", "<C-W>k", opts)
vim.keymap.set("n", "<leader>wh", "<C-W>h", opts)
vim.keymap.set("n", "<leader>wi", "<C-W>l", opts)
vim.keymap.set("n", "<leader>wH", "<C-W>5<", opts)
vim.keymap.set("n", "<leader>wI", "<C-W>5>", opts)
vim.keymap.set("n", "<leader>wN", ":resize +5<CR>", opts)
vim.keymap.set("n", "<leader>wE", ":resize -5<CR>", opts)

-- Telescope
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<esc>"] = require("telescope.actions").close,
			},
		},
	},
})
local telescope = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", function()
	xpcall(function()
		telescope.git_files({
			show_untracked = true,
			use_git_root = false,
		})
	end, function()
		telescope.find_files({
			hidden = true,
		})
	end)
end, opts)
vim.keymap.set("n", "<leader>rg", telescope.live_grep, opts)
vim.keymap.set("n", "<leader>fb", telescope.buffers, opts)
vim.keymap.set("n", "<leader>fh", telescope.help_tags, opts)
vim.keymap.set("n", "<leader>fp", telescope.builtin, opts)

vim.keymap.set("n", "<leader>gc", telescope.git_commits, opts)
vim.keymap.set("n", "<leader>gC", telescope.git_bcommits, opts)
vim.keymap.set("n", "<leader>gs", telescope.git_status, opts)

-- LSP
vim.keymap.set("n", "gr", telescope.lsp_references, opts)
vim.keymap.set("n", "gd", telescope.lsp_definitions, opts)
vim.keymap.set("n", "gi", telescope.lsp_implementations, opts)
vim.keymap.set("n", "gt", telescope.lsp_type_definitions, opts)
vim.keymap.set("n", "<leader>ei", telescope.diagnostics, opts)

vim.keymap.set("n", "<leader>vc", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<leader>vr", vim.lsp.buf.rename, opts)
vim.keymap.set("n", "E", function()
	vim.lsp.buf.hover({ border = "rounded" })
end, opts)
vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
vim.keymap.set("n", "<C-h>", vim.lsp.buf.signature_help, opts)
vim.keymap.set("n", "<leader>en", function()
	vim.diagnostic.jump({ count = 1 })
end, opts)
vim.keymap.set("n", "<leader>ep", function()
	vim.diagnostic.jump({ count = -1 })
end, opts)
