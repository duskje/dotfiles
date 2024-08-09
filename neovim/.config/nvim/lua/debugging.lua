require("dap").adapters['pwa-node'] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = 'node-debug2-adapter', -- using mason config
    args = {'${port}'}
  }
}

local js_based_languages = { "typescript", "javascript", "typescriptreact" }

for _, language in ipairs(js_based_languages) do
  require("dap").configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch debugger NestJS",
      program = "${file}",
      runtimeExecutable = "yarn",
      runtimeArgs = {'run', 'start:debug'},
      port = 9229,
      cwd = "${workspaceFolder}",
    },
--    {
--      type = "pwa-node",
--      request = "attach",
--      name = "Attach to node",
--      processId = require('dap.utils').pick_process({filter = 'node'}),
--      program = "${file}",
--      cwd = "${workspaceFolder}",
--    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Debug NestJS application through port 9229",
      port = 9229,
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = 'integratedTerminal',
    },
  }
end

-- Set keymaps to control the debugger
vim.keymap.set('n', '<F5>', require 'dap'.continue)
vim.keymap.set('n', '<F10>', require 'dap'.step_over)
vim.keymap.set('n', '<F11>', require 'dap'.step_into)
vim.keymap.set('n', '<F12>', require 'dap'.step_out)
-- vim.keymap.set('n', '<leader>b', require 'dap'.toggle_breakpoint)
-- vim.keymap.set('n', '<leader>B', function()
--   require 'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))
-- end)

require("dapui").setup {
    layouts = { {
        elements = { {
            id = "scopes",
            size = 0.25
        }, {
            id = "breakpoints",
            size = 0.25
        }, {
            id = "stacks",
            size = 0.25
        }, {
            id = "watches",
            size = 0.25
        } },
        position = "left",
        size = 40
    }, {
        elements = { 
        {
            id = "repl",
            size = 1
        }, 
--        {
--            id = "console",
--            size = 1
--        } 
    },
        position = "bottom",
        size = 10
    } },
}

local dap, dapui = require("dap"), require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close({})
end
