local submenus = {
    files = '<leader>f',
    code = '<leader>h',
    navigation = '<leader>g',
}

local keybindings = {
-- LSP
    lsp_go_to_declaration = 'gd',
    lsp_go_to_definition = 'gD',
    lsp_go_to_implementation = 'gi',
    lsp_hover = '<leader>H',
    lsp_signature_hints = '<leader>h',
    lsp_file_rename = '<leader>rn',
-- Debugger
    dap_ui_toggle = '<leader>ui',
    dap_continue = '<F5>',
    dap_step_over = '<F10>',
    dap_step_into = '<F11>',
    dap_step_out = '<F12>',
    dap_toggle_breakpoint = '<leader>b',
    dap_expression_breakpoint = '<leader>B',
}

return keybindings
