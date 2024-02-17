vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.wo.number = true

local key_mapper = function(mode, key, result)
    vim.api.nvim_set_keymap(mode,
    key,
    result,
    {noremap = true, silent = true})
end

-- key_mapper('i', 'jk', '<ESC>')
-- key_mapper('v', 'jk', '<ESC>')
-- Diagnostics configuration

vim.g.map_leader = ' '

vim.o.updatetime = 250

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
    callback = function()
        vim.diagnostic.open_float(nil, { focus=false })
    end
})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
})

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end

    return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
    -- packer stuff
    use 'wbthomason/packer.nvim'

    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'

    use {
        'folke/tokyonight.nvim',
        config = function()
            vim.cmd[[colorscheme tokyonight-night]]
        end
    }

    use {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'MunifTanjim/nui.nvim',
            '3rd/image.nvim',
        },
        config = function()
            vim.keymap.set('n', '<A-1>', function()
                vim.cmd[[Neotree toggle]]
            end)
        end
    }

    use {
        'nvimtools/none-ls.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        }
    }

    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets'
        }
    }

    use 'm4xshen/autoclose.nvim'

    use 'ggandor/leap.nvim'

    use 'max397574/better-escape.nvim'

    if packer_bootstrap then
        require('packer').sync()
    end
end)

require('plugins')
