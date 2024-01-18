-- local null_ls = require("null-ls")
-- 
-- null_ls.setup({
--     sources = {
-- --        null_ls.builtins.formatting.stylua,
-- --        null_ls.builtins.diagnostics.tsc,
-- --        null_ls.builtins.completion.spell,
--     }
-- })

require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = {
        'tsserver',
        'eslint',
        'html',
        'cssls',
        'clangd',
    },
})

local cmp = require('cmp')

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        documentation = cmp.config.window.bordered();
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    }),
    completion = { completeopt = '' }
})

local lspconfig = require('lspconfig')

local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.tsserver.setup{
    capabilities = capabilities
}

lspconfig.clangd.setup{
    capabilities = capabilities
}

require('autoclose').setup()
