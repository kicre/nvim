vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- 无网络 / Neovim < 0.12 时只关闭 plugin/ 加载，仍保留原有 options 和 keymaps。
require('config.minimal').setup()

require('config.options')
require('config.keymaps')
