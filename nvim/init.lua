vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                    'vim',
                    'require'
                },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
            format = {
                enable = true,
            },
        },
    },
})

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
vim.wo.relativenumber = true

vim.g.mapleader = " "

vim.o.autoread = true
vim.api.nvim_create_autocmd(
    { "BufEnter", "CursorHold", "CursorHoldI", "FocusGained", },
    {
        command = "if mode() != 'c' | checktime | endif",
        pattern = { "*" },
    }
)

require("plug")

require("nvim-autopairs").setup()

require("nvim-surround").setup()


-- Theme
-- require("catppuccin").setup({
--     flavour = "auto", -- latte, frappe, macchiato, mocha
--     background = {    -- :h background
--         light = "latte",
--         dark = "mocha",
--     },
--     transparent_background = false, -- disables setting the background color.
--     show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
--     term_colors = false,            -- sets terminal colors (e.g. `g:terminal_color_0`)
--     dim_inactive = {
--         enabled = false,            -- dims the background color of inactive window
--         shade = "dark",
--         percentage = 0.15,          -- percentage of the shade to apply to the inactive window
--     },
--     no_italic = true,               -- Force no italic
--     no_bold = false,                -- Force no bold
--     no_underline = false,           -- Force no underline
--     styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
--         comments = { "italic" },    -- Change the style of comments
--         conditionals = {},          --{ "italic" },
--         loops = {},
--         functions = {},
--         keywords = {},
--         strings = {},
--         variables = {},
--         numbers = {},
--         booleans = {},
--         properties = {},
--         types = {},
--         operators = {},
--         -- miscs = {}, -- Uncomment to turn off hard-coded styles
--     },
--     color_overrides = {},
--     custom_highlights = {},
--     default_integrations = true,
--     integrations = {
--         cmp = true,
--         gitsigns = true,
--         nvimtree = true,
--         treesitter = true,
--         notify = false,
--         mini = {
--             enabled = true,
--             indentscope_color = "",
--         },
--         -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
--     },
-- })

-- require("github-theme").setup()
-- require("midnight").setup()
require("gruvbox")

vim.o.background = "dark"
-- vim.cmd("colorscheme catppuccin-mocha")
-- vim.cmd("colorscheme github_dark_tritanopia")
-- vim.cmd("colorscheme midnight")
vim.cmd("colorscheme gruvbox")
-- vim.cmd("highlight Normal guibg=#000000")

require("lualine").setup({
    options = {
        icons_enabled = true,
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        theme = "gruvbox", --catppuccin,gruvbox,tokyonight,kanagawa
    },
})
require("Comment").setup()

-- LSP
local lsp = require("lsp-zero")
lsp.preset("recommended")
vim.lsp.enable({
    "rust_analyzer",
    "pyright",
    "ruff",
    "clangd",
    "taplo",
    "ts_ls",
    "eslint",
    "gopls",
    "emmet_language_server",
})
vim.lsp.config("emmet_language_server", {
    filetypes = { 'xml' }
})
vim.lsp.config("ruff", {
    init_options = {
        settings = {
            organizeImports = true,
            lint = { enable = true },
        },
    },
})
-- mason
require("mason").setup()
require("mason-lspconfig").setup({
    handlers = {
        lsp.default_setup,
    },
})


require("nvim-ts-autotag").setup({
    filetypes = { "html", "xml" },
})


local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
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
    sign_icons = {}
})

lsp.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, virtual_lines = { current_line = true } }) end,
        opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, virtual_lines = { current_line = true } }) end,
        opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, bufopts)
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, bufopts)
    -- vim.keymap.set("i", "jj", "<Esc>", { silent = true })
end)

vim.diagnostic.open_float()
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
        git_clean = false,
        no_buffer = false,
        custom = {},
        exclude = {},
        -- exclude = { ".conf", ".config", ".local" },
    },
    git = {
        enable = true,
        ignore = false,
    },
})
vim.keymap.set("n", "<leader>b", ":NvimTreeFindFileToggle<CR>", {})

-- LangMapper
require('langmapper').automapping({ global = true, buffer = true })

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

-- ruff
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        vim.lsp.buf.format({ async = false })
        vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports" } },
            apply = true,
        })
    end,
})

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    pattern = "*.lua",
    callback = function()
        vim.lsp.buf.format({
            async = true
        })
    end,
})
