-- Colemak bindings
vim.keymap.set("", "n", "j")
vim.keymap.set("", "e", "k")
vim.keymap.set("", "i", "l")
vim.keymap.set("", "I", "$")
vim.keymap.set("", "H", "0")
vim.keymap.set("", "l", "i")
vim.keymap.set("", "L", "I")
vim.keymap.set("n", "N", "mzJ`z")
vim.keymap.set("", "k", "n")
vim.keymap.set("", "K", "N")
vim.keymap.set("", "J", "M")
vim.keymap.set("", "j", "m")
vim.keymap.set("", "m", "e")
vim.keymap.set("", "M", "E")

vim.keymap.set("v", "N", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "E", ":m '<-2<CR>gv=gv")

-- General mappings
vim.keymap.set("", "<BS>", "gg")
vim.keymap.set("", "<CR>", "G")
vim.keymap.set("", "<Space>", "<NOP>")

vim.keymap.set("x", "p", "\"_dP")

vim.keymap.set("n", "<tab>", vim.cmd.bn)
vim.keymap.set("n", "<s-tab>", vim.cmd.bp)
vim.keymap.set("n", "U", vim.cmd.redo)

-- File operation maps
vim.keymap.set("n", "<leader>fd", function ()
    if vim.bo.filetype == "json" then
        vim.cmd("%!jq")
    else
        vim.cmd.normal('jzgg=G`z')
    end
end)
vim.keymap.set("n", "<leader>fs", vim.cmd.w)
vim.keymap.set("n", "<leader>W", vim.cmd.SudaWrite)
vim.keymap.set("n", "<leader>q", vim.cmd.q)
vim.keymap.set("n", "<leader>Q", ":q!<cr>")
vim.keymap.set("n", "<leader>wq", vim.cmd.wq)
vim.keymap.set("n", "<leader>bd", ":bp | bd #<cr>")
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("", "\\", ":let @/ = \"\"<CR>")

-- Git
vim.keymap.set("n", "<leader>gd", vim.cmd.Gvdiff)
-- vim.keymap.set("n", "<leader>gb", vim.cmd('Gitsigns toggle_current_line_blame'))

-- window movement
vim.keymap.set("n", "<leader>wn", "<C-W>j")
vim.keymap.set("n", "<leader>we", "<C-W>k")
vim.keymap.set("n", "<leader>wh", "<C-W>h")
vim.keymap.set("n", "<leader>wi", "<C-W>l")
vim.keymap.set("n", "<leader>wH", "<C-W>5<")
vim.keymap.set("n", "<leader>wI", "<C-W>5>")
vim.keymap.set("n", "<leader>wN", ":resize +5<CR>")
vim.keymap.set("n", "<leader>wE", ":resize -5<CR>")

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fp', builtin.git_files, {})
vim.keymap.set('n', '<c-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>rg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
