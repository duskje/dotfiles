vim.g.mapleader = " "
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.updatetime = 250

vim.wo.number = true

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false })
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
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end

    return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
    -- packer stuff
    use 'wbthomason/packer.nvim'

    -- languages
    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'jay-babu/mason-nvim-dap.nvim'

    use {
      'williamboman/mason-lspconfig.nvim',
      requires = {
        'williamboman/mason.nvim'
      }
    }

    use {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      requires = {
        'williamboman/mason.nvim'
      }
    }

    use {
      'https://gitlab.com/schrieveslaach/sonarlint.nvim',
      requires = {
        'williamboman/mason.nvim'
      }
    }

    use {
        'folke/tokyonight.nvim',
        config = function()
            vim.cmd [[colorscheme tokyonight]]
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
                vim.cmd [[Neotree toggle]]
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
    
--    use {
--        "microsoft/vscode-js-debug",
--        opt = true,
--        run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
--    }

    use 'm4xshen/autoclose.nvim'

    use 'ggandor/leap.nvim'

    use {
        'max397574/better-escape.nvim',
        tag = "v1.0.0"
    }

    use {
        'numToStr/prettierrc.nvim'
    }

    use {
        "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap" , "nvim-neotest/nvim-nio" }
    }

    use { "mxsdev/nvim-dap-vscode-js", requires = { "mfussenegger/nvim-dap" } }

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    use {
        'rmagatti/auto-session',
    }

    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = {'nvim-lua/plenary.nvim'},
    }

    use { 'stevearc/dressing.nvim' }

    -- use { 'xiyaowong/transparent.nvim' }

    use {
        'folke/which-key.nvim',
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 0
        end,
        tag = "v2.1.0"
    }

    use { 'mfussenegger/nvim-lint' }

    if packer_bootstrap then
        require('packer').sync()
    end
end)

require('neo-tree').setup {
    filesystem = {
        hijack_netrw_behavior = 'open_current',
        filtered_items = {
            visible = true
        }
    }
}

require("auto-session").setup {
      log_level = "error",
      pre_save_cmds = {"Neotree close"},
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
}

require('plugins')
require('bar')
require('debugging')

local actions = require("telescope.actions")
local telescope = require('telescope')

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            },
        },
    },
})

local which_key = require('which-key')

which_key.register({
    b = {
        name = "Buffers",
        b = { "<cmd>Telescope buffers<cr>", "Show buffers" },
        n = { "<cmd>enew<cr>", "New buffer" },
        c = { "<cmd>bdelete<cr>", "Close current buffer" },
        d = { function ()
                  local buffers_cmd = vim.api.nvim_exec('buffers', true)
                  local buffers = vim.split(buffers_cmd, '\n')

                  vim.ui.select(buffers,
                                { prompt = "Select buffer to close" },
                                function (choice)
                                    if choice == nil then
                                        return
                                    end

                                    local buffer_id = choice:match(' +(%d+) +')
                                    vim.api.nvim_exec('bdelete ' .. buffer_id, true)
                                    print('Buffer ' .. choice .. ' closed.')
                                end)
              end,
        "Close buffer from menu"}
    },
    f = {
        name = "Files",
        f = { "<cmd>Telescope find_files<cr>", "Find files" },
        g = { "<cmd>Telescope live_grep<cr>", "Live grep" },
        h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
        r = { "<cmd>Telescope oldfiles<cr>", "Open recent File"},
    },
    g = {
        name = "Git",
        b = { "<cmd>Telescope git_branches<cr>", "Show branches"},
        s = { "<cmd>Telescope git_status<cr>", "Show current diff"},
        d = { "<cmd>Telescope git_commits<cr>", "Commits diff"},
    },
    d = {
        name = "Debug",
        b = { require('dap').toggle_breakpoint, "Toggle breakpoint" },
        B = { function ()
                vim.ui.input({ prompt ='Breakpoint condition' },
                    function(input)
                        require('dap').set_breakpoint(input)
                    end)
              end, "Toggle breakpoint expression"
        },
        c = { require('dap').continue, "Continue"},
        v = { require('dap').step_over, "Step over" },
        o = { require('dap').step_out, "Step out" },
        i = { require('dap').step_into, "Step into" },
        u = { require('dapui').toggle, "Toggle UI" },
    },
    n = {
        name = "Navigation",
        r = { "<cmd>Telescope lsp_references<cr>", "References"},
        d = { "<cmd>Telescope lsp_definitions<cr>", "Definitions"},
        c = { "<cmd>Telescope lsp_incoming_calls<cr>", "Incoming calls"},
        C = { "<cmd>Telescope lsp_outgoing_calls<cr>", "Outgoing calls"},
    },
    i = {
        name = "Inspect",
        t = { "<cmd> ", "Type definition"}
    },
    t = {
        name = "Tabs",
        n = { "<cmd>tabnew<cr>", "New tab"},
        d = { "<cmd>tabclose<cr>", "Delete tab"}
    },
}, { prefix = '<leader>' })
