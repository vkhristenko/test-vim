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
	vim.opt.clipboard = "unnamedplus" -- system clipboard
	-- Match classic Vim default rendering instead of truecolor themes.
	vim.opt.termguicolors = true

	vim.opt.signcolumn = "yes"
	vim.opt.cursorline = true
	vim.opt.wrap = true
	vim.opt.linebreak = true
	vim.opt.breakindent = true
	vim.opt.showbreak = "↳ "
	vim.opt.breakindentopt = "shift:4"
	vim.opt.textwidth = 90
	vim.opt.colorcolumn = "91"
	vim.opt.scrolloff = 8
	vim.opt.sidescrolloff = 8
	vim.opt.splitbelow = true
	vim.opt.splitright = true

	-- Tree view
	vim.g.netrw_liststyle = 3

	-- Remove banner at top
	vim.g.netrw_banner = 0

	-- Better window size (25% of screen)
	vim.g.netrw_winsize = 25

	vim.g.netrw_keepdir = 1
	vim.opt.autochdir = false

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
	if n <= 1 then
		return
	end
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

local diagnostic_signs_enabled = true

local function toggle_diagnostic_signs()
	diagnostic_signs_enabled = not diagnostic_signs_enabled
	vim.diagnostic.config({ signs = diagnostic_signs_enabled })

	local state = diagnostic_signs_enabled and "on" or "off"
	vim.notify("Diagnostic signs: " .. state, vim.log.levels.INFO)
end

local function init_remaps_before_plugins()
	vim.keymap.set("n", "G", "G0", { noremap = true })
	local map = vim.keymap.set

	-- Use x-mode (visual only) to avoid select-mode edge cases.
	map("x", "<leader>/", function()
		comment_selection("// ")
	end, { silent = true, desc = "Comment // " })
	map("x", '<leader>"', function()
		comment_selection('" ')
	end, { silent = true, desc = 'Comment " ' })
	map("x", "<leader>#", function()
		comment_selection("# ")
	end, { silent = true, desc = "Comment # " })

	map("n", "<leader>vs6", function()
		split_window_into_n(6)
	end, { silent = true, desc = "6 vertical splits" })
	map("n", "<leader>vs3", function()
		split_window_into_n(3)
	end, { silent = true, desc = "3 vertical splits" })
	map("n", "<leader>tg", cycle_theme, { silent = true, desc = "Cycle theme (vscode/gruvbox/onedark/tokyonight)" })
	map("n", "<leader>gt", cycle_theme, { silent = true, desc = "Cycle theme (vscode/gruvbox/onedark/tokyonight)" })
	map("n", "<leader>td", toggle_diagnostic_signs, { silent = true, desc = "Toggle diagnostic signs" })

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
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{ "sharkdp/fd" },
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
			},
		},
		{
			"lewis6991/gitsigns.nvim",
			config = function()
				require("gitsigns").setup({
					signs = {
						add = { text = "+" },
						change = { text = "~" },
						delete = { text = "_" },
						topdelete = { text = "^" },
						changedelete = { text = "~" },
					},
					signcolumn = true,
					numhl = false,
					linehl = false,
					word_diff = false,
					current_line_blame = true,
					preview_config = {
						border = "rounded",
						style = "minimal",
					},
					on_attach = function(bufnr)
						local gs = package.loaded.gitsigns

						local function map(mode, lhs, rhs, desc)
							vim.keymap.set(mode, lhs, rhs, {
								buffer = bufnr,
								silent = true,
								desc = desc,
							})
						end

						local function toggle_git_diff_visuals()
							local enabled = not vim.b.gitsigns_diff_visuals_enabled
							vim.b.gitsigns_diff_visuals_enabled = enabled

							gs.toggle_linehl(enabled)
							gs.toggle_word_diff(enabled)

							local state = enabled and "on" or "off"
							vim.notify("Git diff visuals: " .. state, vim.log.levels.INFO)
						end

						local function toggle_git_base(revision)
							if vim.b.gitsigns_compare_base == revision then
								gs.reset_base()
								vim.b.gitsigns_compare_base = nil
								vim.notify("Git compare base: index", vim.log.levels.INFO)
								return
							end

							gs.change_base(revision)
							vim.b.gitsigns_compare_base = revision
							vim.notify("Git compare base: " .. revision, vim.log.levels.INFO)
						end

						map("n", "]h", gs.next_hunk, "Next git hunk")
						map("n", "[h", gs.prev_hunk, "Previous git hunk")
						map("n", "<leader>gp", gs.preview_hunk, "Preview git hunk")
						map("n", "<leader>gi", gs.preview_hunk_inline, "Preview git hunk inline")
						map("n", "<leader>gb", gs.blame_line, "Blame current line")
						map("n", "<leader>gd", function()
							toggle_git_diff_visuals()
						end, "Toggle inline git diff visuals")
						map("n", "<leader>gD", function()
							toggle_git_base("~")
						end, "Toggle compare against last commit")
						map("n", "<leader>ts", gs.toggle_signs, "Toggle git signs")
						map("n", "<leader>th", gs.toggle_linehl, "Toggle git line highlight")
						map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle git blame")
						map("n", "<leader>tw", gs.toggle_word_diff, "Toggle word diff")
					end,
				})
			end,
		},
	})
end

local function setup_lsp_keymaps()
	local group = vim.api.nvim_create_augroup("MyLspKeymaps", { clear = true })
	vim.api.nvim_create_autocmd("LspAttach", {
		group = group,
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			local bufnr = args.buf

			if not client then
				return
			end

			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, {
					buffer = bufnr,
					silent = true,
					desc = desc,
				})
			end

			-- Common
			map("n", "<leader>e", vim.diagnostic.open_float, "Open diagnostic float")
			map("n", "[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
			map("n", "]d", vim.diagnostic.goto_next, "Go to next diagnostic")
			map("n", "<leader>q", vim.diagnostic.setloclist, "Set location list")

			map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    		map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    		map("n", "gr", vim.lsp.buf.references, "Go to references")
    		map("n", "K", vim.lsp.buf.hover, "Hover for info")
    		map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
    		map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    		map("n", "<leader>D", vim.lsp.buf.type_definition, "Type definition")
    		map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    		map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")

			if client.name == "clangd" then
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			elseif client.name == "pyright" then
				map("n", "<leader>oi", function()
                    vim.lsp.buf.code_action({
                        apply = true,
                        context = {
                            only = { "source.organizeImports" },
                            diagnostics = {},
                        },
                    })
                end, "Organize imports")

                map("n", "<leader>rf", function()
                    vim.lsp.buf.code_action({
                        apply = true,
                        context = {
                            only = { "source.fixAll" },
                            diagnostics = {},
                        },
                    })
                end, "Fix all")
			end
		end,
	})
end

local function setup_telescope()
	require("telescope").setup({
		defaults = {
			file_ignore_patterns = { "node_modules", ".git" },
		},
	})

	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>ff", builtin.find_files, { silent = true, desc = "Find files" })
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, { silent = true, desc = "Live grep" })
	vim.keymap.set("n", "<leader>fb", builtin.buffers, { silent = true, desc = "Buffers" })
	vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { silent = true, desc = "LSP references" })
end

local function setup_lsp_clangd()
	vim.lsp.config("clangd", {
		cmd = { "clangd", "--background-index", "--clang-tidy" },
	})
	vim.lsp.enable("clangd")
	vim.o.updatetime = 250
	vim.cmd([[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]])
end

local function setup_lsp_pyright()
	vim.lsp.config("pyright", {})
	vim.lsp.enable("pyright")
end

local function setup_colorscheme()
	vim.cmd("colorscheme vscode")
end

local function setup_neo_tree()
	require("neo-tree").setup({
		enable_git_status = true,
		enable_diagnostics = false,
		default_component_configs = {
			indent = {
				expander_collapsed = ">", -- closed folder
				expander_expanded = "v", -- open folder
			},
			size = {
				enabled = true,
				required_width = 0,
				align = "right", -- ✅ this right-aligns the size text
			},
			icon = {
				enabled = true,
				folder_closed = "[+]",
				folder_open = "[-]",
				folder_empty = "[+]",
				default = "  ", -- file icon (blank for clean look)
			},
		},
		window = {
			position = "current",
            mappings = {
              ["<bs>"] = "noop",
            },
		},
		filesystem = {
			hijack_netrw_behavior = "open_current",
		},
	})
end

function M.setup()
	init_global_before_plugins()
	apply_cursorline_contrast()
	init_remaps_before_plugins()
	load_plugins()
	setup_lsp_clangd()
	setup_telescope()
	setup_lsp_pyright()
	setup_colorscheme()
	setup_neo_tree()
	setup_lsp_keymaps()
end

return M
