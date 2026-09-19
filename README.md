# Neovim setup

## Requirements

- Neovim 0.11 or newer
- Git

## Install

Clone the repository anywhere, then run the setup script with Neovim:

```sh
git clone https://github.com/vkhristenko/test-vim.git
cd test-vim
nvim --clean -l setup.lua
```

The script creates `init.lua` in Neovim's configuration directory and installs
`lazy.nvim` in Neovim's data directory. Existing files and installations are kept.

Start Neovim normally to install the configured plugins:

```sh
nvim
```
