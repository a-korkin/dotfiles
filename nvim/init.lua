vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true
vim.g.termiguicolors = true
vim.wo.number = true
vim.opt.scrolloff = 10
vim.opt.colorcolumn = '80'
vim.opt.linebreak = false
vim.opt.hlsearch = false
vim.opt.swapfile = true
vim.opt.guicursor = ""
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"
-- vim.opt.signcolumn = "yes:1"

vim.g.mapleader = " "

vim.o.autoread = true
vim.api.nvim_create_autocmd(
    { "BufEnter", "CursorHold", "CursorHoldI", "FocusGained", },
    {
        command = "if mode() != 'c' | checktime | endif",
        pattern = {"*"},
    }
)

require("plug")

require("nvim-autopairs").setup()

-- Theme
require("catppuccin").setup({
    flavour = "auto", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = true, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = {}, --{ "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    custom_highlights = {},
    default_integrations = true,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

vim.o.background = "dark"
vim.cmd("colorscheme catppuccin-mocha")
-- vim.o.background = "light"
-- vim.cmd("colorscheme catppuccin-latte")

require("lualine").setup {
    options = {
        icons_enabled = true,
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        theme = "catppuccin",
        -- theme = "gruvbox",
        -- theme = "tokyonight",
        -- theme = "kanagawa",
    },
}
require("Comment").setup()
-- require("nvim-tree").setup()
-- require("nerdtree").setup()

-- LSP
local lsp = require("lsp-zero")
lsp.preset("recommended")
lsp.setup_servers({
    "rust_analyzer",
    "pyright",
    "clangd",
    "taplo",
    "ts_ls",
    "eslint",
    "gopls",
})
-- mason
require("mason").setup()
require("mason-lspconfig").setup({
    handlers = {
        lsp.default_setup,
    },
})

local lspconfig = require("lspconfig");
lspconfig.emmet_language_server.setup({
    filetypes = { 'xml' },
})

-- require'nvim-treesitter.configs'.setup {
--     autotag = {
--         enable = true,
--     }
-- }

-- Python
-- require("dressing").setup({})
-- require("swenv.api").pick_venv()

require("nvim-ts-autotag").setup({
    filetypes = { "html", "xml" },
})


local cmp = require("cmp")
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local lspkind = require("lspkind")

cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-k>'] = cmp.mapping.scroll_docs(-3),
        ['<C-l>'] = cmp.mapping.scroll_docs(4),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<Tab>"] = cmp.mapping.select_next_item(cmp_select),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = {
                menu = 50,
                abbr = 50,
            },
        })
    }
})

lsp.set_preferences({
    sign_icons = { }
})

lsp.on_attach(function(_, bufnr)
    local opts = {buffer = bufnr, remap = false}
    local bufopts = {noremap = true, silent = true, buffer = bufnr}
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<Space>e", vim.diagnostic.open_float, bufopts)
    vim.keymap.set("i", "jj", "<ESC>", {silent = true})
end)

vim.diagnostic.open_float()

lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
lsp.setup()

-- Rust tools
-- local rt = require("rust-tools")
-- rt.setup({
--   server = {
--     on_attach = function(_, bufnr)
--       -- Hover actions
--       vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
--       -- Code action groups
--       vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
--     end,
--   },
-- })
-- rt.inlay_hints.enable()

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- NvimTree
require("nvim-tree").setup({
    view = {
        width = 50,
    },
    filters = {
        dotfiles = false,
        exclude = { ".conf", ".config", ".local" },
    },
})
vim.keymap.set("n", "<leader>b", ":NvimTreeToggle<CR>", {})
vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>", {})

-- LangMapper
require('langmapper').automapping({ global = true, buffer = true })

-- html
-- require('html-css').setup({})

local function escape(str)
    -- You need to escape these characters to work correctly
    local escape_chars = [[;,."|\]]
    return vim.fn.escape(str, escape_chars) 
end

-- Recommended to use lua template string
-- Recommended to use lua template string
local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

vim.opt.langmap = vim.fn.join({
    -- | `to` should be first     | `from` should be second
    escape(ru_shift) .. ';' .. escape(en_shift),
    escape(ru) .. ';' .. escape(en),
}, ',')

-- gofmt
require("go").setup()
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        require("go.format").gofmt()
    end,
    group = format_sync_grp,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.rs",
    command = "RustFmt",
})

