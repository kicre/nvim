-- 全局快捷键：参考 wsdjeg 的 Neovim 配置管理最佳实践整理
-- 规范：每个映射都带 desc（which-key 弹窗可读）；leader 在 init.lua 中设置

local map = vim.keymap.set

-- 文件 / 常用操作 -----------------------------------------------------
map('n', '<leader>w', '<cmd>write<cr>', { desc = '保存文件' })
map('n', '<leader>q', '<cmd>quit<cr>', { desc = '退出' })
map('n', '<leader>Q', '<cmd>quit!<cr>', { desc = '强制退出' })
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = '清除搜索高亮' })

-- 窗口导航 -------------------------------------------------------------
map('n', '<C-h>', '<C-w>h', { desc = '左窗口' })
map('n', '<C-j>', '<C-w>j', { desc = '下窗口' })
map('n', '<C-k>', '<C-w>k', { desc = '上窗口' })
map('n', '<C-l>', '<C-w>l', { desc = '右窗口' })

-- 窗口大小 -------------------------------------------------------------
map('n', '<C-Up>', '<cmd>resize -2<cr>', { desc = '增高窗口' })
map('n', '<C-Down>', '<cmd>resize +2<cr>', { desc = '压低窗口' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = '变窄窗口' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = '变宽窗口' })

-- 缓冲区 ---------------------------------------------------------------
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = '上一个缓冲区' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = '下一个缓冲区' })

-- 插件管理（vim.pack） --------------------------------------------------
map('n', '<leader>pu', '<cmd>PackUpdate<cr>', { desc = 'Pack: 更新插件' })
map('n', '<leader>pi', '<cmd>PackInfo<cr>', { desc = 'Pack: 插件信息' })

-- 可视模式 ---------------------------------------------------------------
-- 保持缩进后仍选中相同区域
map('v', '<', '<gv', { desc = '减少缩进（保持选区）' })
map('v', '>', '>gv', { desc = '增加缩进（保持选区）' })
