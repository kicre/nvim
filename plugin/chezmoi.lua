--- chezmoi.nvim：编辑 chezmoi 管理的 dotfiles（源文件），保存后自动 apply
--- 依赖 plenary.nvim；picker 使用 snacks.picker
--- 按需初始化：首次触发 <leader>c* 键位才 setup
--
-- 概念：:ChezmoiEdit 打开的是 chezmoi **源文件**（~/.local/share/chezmoi/dot_*），
-- watch 模式下保存源文件即执行 `chezmoi apply --source-path` 同步到目标。

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
    gh('xvzc/chezmoi.nvim'),
    gh('nvim-lua/plenary.nvim'), -- chezmoi 依赖
  },
  { confirm = false } -- 首次安装/断点续装时不弹确认框
)

-- 幂等初始化：只在首次触发时执行
local ensure = once(function()
  require('chezmoi').setup({
    edit = {
      watch = true, -- ChezmoiEdit 打开源文件后，保存自动 apply
      force = false, -- 不强制覆盖（chezmoi 检测到有未提交变更时会报错而非静默覆盖）
      -- 命中这些 Lua pattern 的**源文件名**（basename）不自动 apply；
      -- 如想忽略 matugen 模板目录（dot_config/matugen/templates/*），
      -- 可追加一个匹配模板文件名后缀的 pattern，例如：
      --   '%.(toml|css|ini|json|conf|ron|py|kvc)$',
      ignore_patterns = {
        'run_onchange_.*',
        'run_once_.*',
        '%.chezmoiignore',
        '%.chezmoitemplate',
        '%.chezmoiexternal.*',
        '%.chezmoiroot',
        '%.chezmoiversion',
      },
    },
    -- events.on_open / on_watch / on_apply 默认已开启通知；
    -- 需要静默时可设 notification = { enable = false }，或提供 override 函数。
  })
end)

-- 打开 chezmoi 托管文件列表（snacks picker）
vim.keymap.set('n', '<leader>co', function()
  ensure()
  require('chezmoi.pick').snacks()
end, { desc = 'Chezmoi: open managed file' })

-- 编辑当前文件的 chezmoi 源文件（--watch 开自动 apply）
vim.keymap.set('n', '<leader>ce', function()
  ensure()
  vim.cmd('ChezmoiEdit --watch')
end, { desc = 'Chezmoi: edit source (watch)' })

-- 手动把当前 buffer（作为源文件）立刻 apply 到目标
vim.keymap.set('n', '<leader>ca', function()
  ensure()
  local src = vim.api.nvim_buf_get_name(0)
  require('chezmoi.commands').apply({ args = { '--source-path', src } })
end, { desc = 'Chezmoi: apply current source' })
