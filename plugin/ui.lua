--- UI：transparent / lualine / which-key / snacks / 配色
--- neo-tree、trouble 按需初始化（首次按键才 setup）
local function gh(repo)
  return 'https://github.com/' .. repo
end

local function once(fn)
  local ran = false
  return function(...)
    if ran then return end
    ran = true
    return fn(...)
  end
end

vim.pack.add(
  {
    gh('xiyaowong/transparent.nvim'), -- 透明背景（需在配色前 setup）
    gh('nvim-lualine/lualine.nvim'),
    gh('nvim-tree/nvim-web-devicons'),
    gh('folke/which-key.nvim'),
    gh('folke/trouble.nvim'),
    gh('folke/snacks.nvim'), -- 唯一 picker（无外部二进制依赖）
    { src = gh('nvim-neo-tree/neo-tree.nvim'), version = 'v3.x' },
    gh('nvim-lua/plenary.nvim'), -- neo-tree 依赖
    gh('MunifTanjim/nui.nvim'), -- neo-tree 依赖
  },
  { confirm = false } -- 首次安装/断点续装时不弹确认框
)

-- neo-tree.nvim：文件树（依赖 plenary/nui/devicons），首次按 <leader>e 才 setup
local ensure_neotree = once(function()
  require('neo-tree').setup({})
end)

-- trouble.nvim：首次触发 gd/gr/gi/<leader>xx/<leader>o 才 setup
local ensure_trouble = once(function()
  require('trouble').setup({})
end)

--- 生成「先确保加载，再执行 Trouble 命令」的键位回调
local function trouble_cmd(args)
  return function()
    ensure_trouble()
    vim.cmd('Trouble ' .. args)
  end
end

-- transparent.nvim ----------------------------------------------------------
if vim.fn.filereadable(vim.fn.stdpath('data') .. '/transparent_cache') == 0
  and vim.g.transparent_enabled == nil then
  vim.g.transparent_enabled = true
end
require('transparent').setup({
  groups = {
    'Normal', 'NormalNC', 'EndOfBuffer', 'Folded', 'FoldColumn',
    'SignColumn', 'StatusLineNC', 'CursorLine', 'CursorColumn',
  },
})

-- lualine.nvim（依赖 nvim-web-devicons）
require('lualine').setup({})

-- which-key.nvim
require('which-key').setup({
  -- 与整体 UI 统一使用圆角边框
  win = {
    border = 'rounded',
  },
  -- 给常用前缀命名，弹窗里显示分组标题
  spec = {
    { '<leader>f', group = 'Find' },
    { '<leader>p', group = 'Pack' },
    { '<leader>c', group = 'Chezmoi' },
  },
})
-- 查看当前 buffer 的局部键位
vim.keymap.set('n', '<leader>?', function()
  require('which-key').show({ global = false })
end, { desc = 'WhichKey: buffer local keymaps' })

-- snacks.nvim
-- dashboard（不依赖 lazy.nvim 的 sections）+ 主 picker（唯一 picker，无外部二进制依赖）
require('snacks').setup({
  dashboard = {
    -- 默认 sections 里的 { section = 'startup' } 依赖 lazy.nvim
    -- （require('lazy.stats')），这里显式替换为不含它的列表
    sections = {
      { section = 'header' },
      { section = 'keys', gap = 1, padding = 1 },
    },
    preset = {
      header = [[
      ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
      ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
      ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
      ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
      ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
      ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
]],
      -- stylua: ignore
      keys = {
        { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
        { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
        { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
        { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
        { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
        { icon = '󰒲 ', key = 'l', desc = 'Update Packs', action = function()
          vim.pack.update()
        end },
        { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
      },
    },
  },
})

-- 主 picker 键位（snacks.picker；内部别名：find_files/live_grep/oldfiles）
vim.keymap.set('n', '<leader>ff', function()
  Snacks.picker.pick('files')
end, { desc = 'Snacks: find files' })
vim.keymap.set('n', '<leader>fg', function()
  Snacks.picker.pick('grep')
end, { desc = 'Snacks: live grep' })
vim.keymap.set('n', '<leader>fr', function()
  Snacks.picker.pick('recent')
end, { desc = 'Snacks: recent files' })
vim.keymap.set('n', '<leader>fb', function()
  Snacks.picker.pick('buffers')
end, { desc = 'Snacks: buffers' })
vim.keymap.set('n', '<leader>fz', function()
  Snacks.picker.pick('lines')
end, { desc = 'Snacks: grep current buffer' })

-- neo-tree.nvim（按需）
vim.keymap.set('n', '<leader>e', function()
  ensure_neotree()
  vim.cmd('Neotree toggle')
end, { desc = 'Toggle Neo-tree' })

-- trouble.nvim（按需）
vim.keymap.set('n', 'gr', trouble_cmd('lsp_references toggle'), { desc = 'Trouble references' })
vim.keymap.set('n', 'gd', trouble_cmd('lsp_definitions toggle'), { desc = 'Trouble definitions' })
vim.keymap.set('n', 'gi', trouble_cmd('lsp_implementations toggle'), { desc = 'Trouble implementations' })
vim.keymap.set('n', '<leader>xx', trouble_cmd('diagnostics toggle'), { desc = 'Trouble diagnostics' })
vim.keymap.set('n', '<leader>o', trouble_cmd('symbols toggle win.position=right'), { desc = 'Trouble symbols' })

-- Penumbra 配色（colors/penumbra.lua 在标准 runtimepath 中）
vim.cmd.colorscheme('penumbra')
