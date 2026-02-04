return {
    {
        'folke/tokyonight.nvim',
        config = function()
            vim.cmd [[colorscheme tokyonight]]
        end
    },
    {
        'rcarriga/nvim-notify',
        opts = {
            render = "default",
            stages = "static",
        }
    },
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'MunifTanjim/nui.nvim',
        },
        lazy = false,
        opts = {
            close_if_last_window = true,
            filesystem = {
                hijack_netrw_behavior = 'open_current',
                filtered_items = {
                    visible = true
                }
            }
        },
        config = function(_, opts)
            vim.keymap.set('n', '<A-1>', function()
                vim.cmd [[Neotree toggle]]
            end)

            require("neo-tree").setup(opts)
        end
    },
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
    {
        'm4xshen/autoclose.nvim',
        opts = {},
    },
    {
        'ggandor/leap.nvim',
        config = function()
            require('leap').create_default_mappings()
        end
    },
    {
        'max397574/better-escape.nvim',
        opts =  {
            mapping = { 'jk' },
            timeout = 100,
            clear_empty_lines = false,
            keys = '<Esc>',
        },
        version = "v1.0.0"
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
    },
    {
        'rmagatti/auto-session',
        lazy = false,
        opt = {
            show_auto_restore_notif = true,
            suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        },
    },

    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.8',
        dependencies = {'nvim-lua/plenary.nvim'},
        config = function()
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

        end
    },
    { 'stevearc/dressing.nvim' },
    {
        'folke/which-key.nvim',
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 0
        end,
        version = "v2.1.0"
    },
    {
        'mfussenegger/nvim-lint',
        config = function()
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
        end,
    }
}
