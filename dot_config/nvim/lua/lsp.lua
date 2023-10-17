-- Load default lsp-zero keymaps
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(_, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({buffer = bufnr})

    local opts = {buffer = bufnr, remap = false}
    vim.keymap.set("n", "<leader>vw", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vc", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vr", function() vim.lsp.buf.rename() end, opts)

    vim.keymap.set("n", "<leader>en", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "<leader>ep", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp_zero.format_on_save({
    format_opts = {
        async = true,
        timeout_ms = 10000,
    },
    servers = {
        ['prettier'] = {'javascript', 'typescript'},
        ['gopls'] = {'go'},
        ['stylua'] = {'lua'},
    }
})

-- Setup LSP servers
local lspconfig = require('lspconfig')
-- go
lspconfig.golangci_lint_ls.setup({})
lspconfig.gopls.setup({})
-- lua
lspconfig.lua_ls.setup({})
-- python
lspconfig.pylsp.setup{}
-- typescript
lspconfig.tsserver.setup({})
lspconfig.eslint.setup({})
-- other
lspconfig.terraformls.setup({})
lspconfig.jsonls.setup({})

-- Customize keymaps
local cmp = require('cmp')
-- local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        -- `Enter` key to confirm completion
        ['<CR>'] = cmp.mapping.confirm({select = false}),

        ['<C-Space>'] = cmp.mapping.complete(),

        -- Scroll up and down in the completion documentation
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
    })
})

-- Fix lua lsp for nvim config
local lua_opts = lsp_zero.nvim_lua_ls()
require('lspconfig').lua_ls.setup(lua_opts)

require("mason").setup()
