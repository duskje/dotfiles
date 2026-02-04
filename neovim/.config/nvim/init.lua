vim.g.mapleader = " "
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.updatetime = 250

vim.wo.number = true

vim.g.enable_floating_diagnostic = false

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
    callback = function()
        if vim.g.enable_floating_diagnostic then
            vim.diagnostic.open_float(nil, { focus = false })
        end
    end
})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
	float = {
		border = "rounded",
		format = function(diagnostic)
			return string.format(
				"%s (%s) [%s]",
				diagnostic.message,
				diagnostic.source,
				diagnostic.code or diagnostic.user_data.lsp.code
			)
		end,
	},
})

vim.keymap.del('n', 'gra')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'grt')
vim.keymap.del('n', 'gO')

require("config.lazy")

vim.notify = require("notify")

require('bar')
require('lsp')

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
    x = {
        "Diagnostics",
        d = {
            function()
                vim.g.enable_floating_diagnostic = not vim.g.enable_floating_diagnostic
            end,
            "Toggle diagnostics floating window",
        }
    },
}, { prefix = '<leader>' })
