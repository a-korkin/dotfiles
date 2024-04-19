vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
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
-- vim.opt.signcolumn = "yes:1"

vim.g.mapleader = " "

require("plug")

require("nvim-autopairs").setup()

-- Theme
-- require("catppuccin").setup({
--     flavour = "mocha",
--     no_italic = true,
-- })
-- vim.cmd [[colorscheme catppuccin]]

-- require("tokyonight").setup({
--     style = "storm",
-- })
-- vim.cmd[[colorscheme tokyonight]]

-- require("vscode").setup({})
-- vim.cmd[[colorscheme vscode]]

require("gruvbox").setup({
    italic = {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = false,
    },
    contrast = "", -- hard, soft
})
vim.o.background = "dark"
vim.cmd[[colorscheme gruvbox]]

require("lualine").setup {
    options = {
        icons_enabled = true,
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        -- theme = "catppuccin",
        theme = "gruvbox",
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
    "tsserver",
    "eslint",
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

-- Arduino
-- require("arduino").setup ({
--     default_fqbn = "arduino:avr:uno",
--     clangd = require 'mason-core.path'.bin_prefix 'clangd',
--     arduino = "/usr/bin/arduino-cli",
-- })

local cmp = require("cmp")
local cmp_select = {behavior = cmp.SelectBehavior.Select}
-- local cmp_action = lsp.cmp_action()

cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-k>'] = cmp.mapping.scroll_docs(-3),
        ['<C-l>'] = cmp.mapping.scroll_docs(4),
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    })
})

lsp.set_preferences({
    sign_icons = { }
})

lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts) vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
end)

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

