local M = {}

-- Function to initialize global settings before plugins
local function init_global_before_plugins()
	-- Leader (useful later)
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	vim.opt.expandtab = true
	vim.opt.shiftwidth = 4
	vim.opt.tabstop = 4
	vim.opt.softtabstop = 4
	vim.opt.smartindent = true

	vim.opt.number = true
	vim.opt.relativenumber = false
	vim.opt.mouse = "a"
	vim.opt.clipboard = "unnamedplus"     -- system clipboard
	-- Match classic Vim default rendering instead of truecolor themes.
	vim.opt.termguicolors = true 

	vim.opt.signcolumn = "yes"
	vim.opt.cursorline = true
	vim.opt.wrap = true
	vim.opt.linebreak = true
	vim.opt.breakindent = true
	vim.opt.textwidth = 90
	vim.opt.colorcolumn = "91"
	vim.opt.scrolloff = 8
	vim.opt.sidescrolloff = 8
	vim.opt.splitbelow = true
	vim.opt.splitright = true

	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.incsearch = true
	vim.opt.hlsearch = true

	vim.opt.swapfile = false
	vim.opt.backup = false
	vim.opt.undofile = true
	vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"

	vim.opt.updatetime = 200
	vim.opt.timeoutlen = 400

	-- Filetypes/syntax (Neovim has this on by default, but explicit is fine)
	vim.cmd("syntax enable")
	vim.cmd("filetype plugin indent on")
	vim.opt.background = "dark"
end

local function apply_cursorline_contrast()
	if vim.o.background == "dark" then
		vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2b3444" })
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffd166", bold = true })
	else
		vim.api.nvim_set_hl(0, "CursorLine", { bg = "#d9e2ef" })
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#005f87", bold = true })
	end
end

local cursorline_group = vim.api.nvim_create_augroup("CursorLineContrast", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	group = cursorline_group,
	callback = apply_cursorline_contrast,
})

-- Comment out visual selection with a prefix, skipping already-commented lines.
-- Usage: visually select lines, then press your mapped key.
local function comment_selection(prefix)
	-- In Lua visual mappings, '< and '> can point to a stale selection.
	-- Use current visual anchors (v and .) and normalize direction.
	local start_line = vim.fn.line("v")
	local end_line = vim.fn.line(".")
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end

	-- Escape prefix for Lua pattern matching
	local esc = vim.pesc(prefix)

	for lnum = start_line, end_line do
		local line = vim.fn.getline(lnum)
		-- Skip if already commented with the exact prefix at column 1
		if not line:match("^" .. esc) then
			vim.fn.setline(lnum, prefix .. line)
		end
	end
end

-- Split current window into N vertical splits (total N windows)
local function split_window_into_n(n)
	n = tonumber(n) or 1
	if n <= 1 then return end
	for _ = 2, n do
		vim.cmd("vsplit")
	end
end


local function cycle_theme()
	local current = vim.g.colors_name or ""
	local idx = 0

	local theme_cycle = { "vscode", "gruvbox", "onedark", "tokyonight" }
	for i, name in ipairs(theme_cycle) do
		if name == current then
			idx = i
			break
		end
	end

	local next_name = theme_cycle[(idx % #theme_cycle) + 1]
	local ok, err = pcall(vim.cmd.colorscheme, next_name)
	if ok then
		vim.notify("Colorscheme: " .. next_name, vim.log.levels.INFO)
	else
		vim.notify("Failed to load " .. next_name .. ": " .. tostring(err), vim.log.levels.WARN)
	end
end

local function init_remaps_before_plugins()
	vim.keymap.set("n", "G", "G0", { noremap = true })
	local map = vim.keymap.set

	-- Use x-mode (visual only) to avoid select-mode edge cases.
	map("x", "<leader>/", function() comment_selection("// ") end, { silent = true, desc = "Comment // " })
	map("x", '<leader>"', function() comment_selection('" ') end,  { silent = true, desc = 'Comment " ' })
	map("x", "<leader>#", function() comment_selection("# ") end,   { silent = true, desc = "Comment # " })

	map("n", "<leader>vs6", function() split_window_into_n(6) end, { silent = true, desc = "6 vertical splits" })
	map("n", "<leader>vs3", function() split_window_into_n(3) end, { silent = true, desc = "3 vertical splits" })
	map("n", "<leader>tg", cycle_theme, { silent = true, desc = "Cycle theme (vscode/gruvbox/onedark/tokyonight)" })
	map("n", "<leader>gt", cycle_theme, { silent = true, desc = "Cycle theme (vscode/gruvbox/onedark/tokyonight)" })

	map("x", "<leader>cy", '"+y', { silent = true, desc = "Copy to clipboard" })
end

local function load_plugins()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	vim.opt.rtp:prepend(lazypath)

	require("lazy").setup({
	  {
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
		  require("nvim-treesitter.config").setup({
			ensure_installed = { "lua", "cpp", "c", "python", "bash" },
			highlight = { enable = true },
			indent = { enable = true },
		  })
		end,
	  },
	  { "neovim/nvim-lspconfig" },
      { "github/copilot.vim" },
      { "Mofiqul/vscode.nvim" },
      { "ellisonleao/gruvbox.nvim" },
	  { "navarasu/onedark.nvim" },
	  { "folke/tokyonight.nvim" },
	  {
		  "nvim-telescope/telescope.nvim",
		  dependencies = { "nvim-lua/plenary.nvim",},
	  },
	  { "sharkdp/fd" },
	})
end

local function setup_lsp_clangd()
	vim.lsp.config("clangd", {
	  cmd = { "clangd", "--background-index", "--clang-tidy" },
	})

	vim.lsp.enable("clangd")

	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

	vim.o.updatetime = 250
	vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]]
end

local function setup_lsp_pyright()
	vim.lsp.config("pyright", {})
	vim.lsp.enable("pyright")
end

local function setup_telescopr()
	local telescope = require("telescope.builtin")

	vim.keymap.set("n", "<leader>ff", telescope.find_files)
	vim.keymap.set("n", "<leader>fg", telescope.live_grep)
	vim.keymap.set("n", "<leader>fb", telescope.buffers)
	vim.keymap.set("n", "<leader>fr", telescope.lsp_references)
end

local function setup_colorscheme()
	vim.cmd("colorscheme vscode")
end

function M.setup()
    init_global_before_plugins()
    apply_cursorline_contrast()
    init_remaps_before_plugins()
    load_plugins()
    setup_lsp_clangd()
    setup_telescopr()
    setup_lsp_pyright()
    setup_colorscheme()
end

return M
