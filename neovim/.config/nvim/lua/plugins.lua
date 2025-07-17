require('autoclose').setup()
require("mason").setup()

local language_servers = {
--     'ts_ls',
    'eslint',
    'html',
    'cssls',
    'clangd',
    'lua_ls',
    'pyright',
--    'volar', -- esto es el vue language server
}

require("mason-lspconfig").setup({
  ensure_installed = language_servers,
})

local linters = {
    'actionlint', -- esto es githubactions
    -- 'sonarlint-language-server',
    -- 'prettierd',
    'shellcheck',
}

require("mason-tool-installer").setup({
    ensure_installed=linters,
})

local cmp = require('cmp')

require('luasnip.loaders.from_vscode').lazy_load()

local luasnip = require('luasnip')

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

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

for _, language_server in ipairs(language_servers) do
  lspconfig[language_server].setup {
    capabilities = capabilities
  }
end

local lint = require("lint")

lint.linters_by_ft = {
  sh = { "shellcheck" },
  yaml = { "actionlint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
  callback = function()

    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    lint.try_lint()

    -- You can call `try_lint` with a linter name or a list of names to always
    -- run specific linters, independent of the `linters_by_ft` configuration
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gr', function() vim.cmd[[Telescope lsp_references]] end, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

require('leap').create_default_mappings()

require('better_escape').setup {
  mapping = { 'jk' },
  timeout = vim.o.timeoutlen,
  clear_empty_lines = false,
  keys = '<Esc>',
}

require('sonarlint').setup({
   server = {
      cmd = {
         'sonarlint-language-server',
         -- Ensure that sonarlint-language-server uses stdio channel
         '-stdio',
         '-analyzers',
         -- paths to the analyzers you need, using those for python and java in this example
         -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
         -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
         -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
      }
   },
   filetypes = {
     'js'
      -- Tested and working
      --'python',
      --  'cpp',
      --  'java',
   }
})
