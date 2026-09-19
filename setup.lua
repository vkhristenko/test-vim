-- Run with: nvim --clean -l setup.lua

local function fail(message)
	error(message, 0)
end

local source = debug.getinfo(1, "S").source
if source:sub(1, 1) ~= "@" then
	fail("Could not determine the location of setup.lua")
end

local repo_dir = vim.fn.fnamemodify(source:sub(2), ":p:h")
local module_path = repo_dir .. "/lua/my_nvim_setup/init.lua"
local config_dir = vim.fn.stdpath("config")
local init_path = config_dir .. "/init.lua"
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(module_path) then
	fail("my_nvim_setup was not found under " .. repo_dir)
end

vim.fn.mkdir(config_dir, "p")

if vim.uv.fs_stat(init_path) then
	print("Keeping existing " .. init_path)
else
	local lines = {
		("local my_setup_path = %q"):format(repo_dir),
		"",
		"vim.opt.rtp:prepend(my_setup_path)",
		'require("my_nvim_setup").setup()',
	}

	local result = vim.fn.writefile(lines, init_path)
	if result ~= 0 then
		fail("Could not write " .. init_path)
	end
	print("Created " .. init_path)
end

if vim.uv.fs_stat(lazy_path .. "/.git") then
	print("lazy.nvim is already installed at " .. lazy_path)
elseif vim.uv.fs_stat(lazy_path) then
	fail(lazy_path .. " exists but is not a Git checkout")
else
	if vim.fn.executable("git") ~= 1 then
		fail("git is required to install lazy.nvim")
	end

	vim.fn.mkdir(vim.fs.dirname(lazy_path), "p")
	local result = vim.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazy_path,
	}, { text = true }):wait()

	if result.code ~= 0 then
		fail("Could not install lazy.nvim:\n" .. (result.stderr or result.stdout or "unknown error"))
	end
	print("Installed lazy.nvim at " .. lazy_path)
end

print("Neovim setup complete. Run nvim to install the configured plugins.")
