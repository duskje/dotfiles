require('tokyonight').setup {
    style='night',
    sidebars={'qf', 'help'},
    -- hide_inactive_statusline=true,
    lualine_bold=true,
    dim_inactive=true,
}

require('lualine').setup {
    options = {
        theme = 'tokyonight' ,
        disabled_filetypes = {
            statusline = {'packer', 'neo-tree', 'neo-tree-popup'}
        }
    },
}
