local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
    use("windwp/nvim-autopairs")

    -- Themes
    use("Mofiqul/dracula.nvim")
    use("shaunsingh/nord.nvim")
    use("ellisonleao/gruvbox.nvim")
    use("projekt0n/github-nvim-theme")
    use{"catppuccin/nvim", as = "catppuccin"}
    use("folke/tokyonight.nvim")
    use("Mofiqul/vscode.nvim")
    use("dasupradyumna/midnight.nvim")
    use("rebelot/kanagawa.nvim")

    use({
        "nvim-lualine/lualine.nvim",
    })

    use("nvim-tree/nvim-tree.lua")

    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    })

    use {
	"VonHeikemen/lsp-zero.nvim",
	branch = "v3.x",
	requires = {
	        -- LSP Support    
            {
                "neovim/nvim-lspconfig",
                opts = {
                    inlay_hints = { enable = true },
                },
            },
            {"williamboman/mason.nvim"},
            {"williamboman/mason-lspconfig.nvim"},
            -- Autocompletion
            {"hrsh7th/nvim-cmp"},
            {"hrsh7th/cmp-nvim-lsp"},
            -- {"ms-jpq/coq_nvim", branch = "coq"},
            -- {"ms-jpq/coq.artifacts", branch = "artifacts"},
            -- {"ms-jpq/coq.thirdparty", branch = "3p"},
            {"L3MON4D3/LuaSnip"},
    	}
    }

    -- Telescope
    use {
        "nvim-telescope/telescope.nvim", tag = "0.1.5",
        requires = { { "nvim-lua/plenary.nvim" } }
    }
    -- Arduino
    use({"edKotinsky/Arduino.nvim", as = "arduino"})

    -- Rust
    use("simrat39/rust-tools.nvim")

    -- Python
    use("AckslD/swenv.nvim")
    use("stevearc/dressing.nvim")

    -- LangMapper
    use({
        'Wansmer/langmapper.nvim',
        config = function()
            require('langmapper').setup({})
        end,
    })

    use("nvim-treesitter/nvim-treesitter")
    use("windwp/nvim-ts-autotag")
    -- use({"onsails/lspkind-nvim",
    --     config=function()
    --         require("plugins/lspkind")
    --     end
    -- })
    use("onsails/lspkind-nvim")
    use("ray-x/go.nvim")

    -- use({
    --     "kylechui/nvim-surround",
    --     tag = "*",
    --     config = function()
    --         require("nvim-surround").setup({})
    --     end
    -- })
end)

-- the first run will install packer and our plugins
if packer_bootstrap then
	require("packer").sync()
	return
end
