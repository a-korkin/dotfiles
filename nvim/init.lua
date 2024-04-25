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

require("nvim-ts-autotag").setup({
    filetypes = { "html", "xml" },
})

local cmp = require("cmp")
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_insert = {behavior = cmp.SelectBehavior.Insert}
local lspkind = require("lspkind")

cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        ['<C-l>'] = cmp.mapping.scroll_docs(4),
        -- ["<C-p>"] = cmp.mapping.select_prev_item(cmp_insert),
        -- ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        -- ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<Tab>"] = cmp.mapping.select_next_item(cmp_select),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    formatting = {
        format = lspkind.cmp_format({
            mode = "text_symbol",
            maxwidth = 50,
        })
    }
})

-- cmp.setup.cmdline({
--     mapping = cmp.mapping.preset.cmdline({
--         ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
--         ["<C-y>"] = cmp.mapping.select_next_item(cmp_select),
--     })
-- })

lsp.set_preferences({
    sign_icons = { }
})

lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
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

