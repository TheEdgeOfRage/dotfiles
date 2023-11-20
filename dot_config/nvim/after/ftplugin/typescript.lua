local opts = { noremap = true, silent = true }

-- jester mappings
local jester = require("jester")
vim.keymap.set("n", "<leader>tt", jester.run, opts)
vim.keymap.set("n", "<leader>tl", jester.run_last, opts)
vim.keymap.set("n", "<leader>tf", jester.run_file, opts)
vim.keymap.set("n", "<leader>tdt", jester.debug, opts)
vim.keymap.set("n", "<leader>tdl", jester.debug_last, opts)
vim.keymap.set("n", "<leader>tdf", jester.debug_file, opts)
