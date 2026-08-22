--- 编辑增强：mini.pairs / nvim-surround / nvim-colorizer / treesitter
--- conform.nvim 按需初始化（首次按 <M-f> 才 setup）

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

-- PackChanged 钩子：treesitter 安装/更新后重建 parser
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      -- PackChanged 可能在插件被 :packadd 之前触发，先确保已加载
      vim.cmd.packadd('nvim-treesitter')
      vim.cmd.TSUpdate()
    end
  end,
})

vim.pack.add(
  {
    gh('nvim-mini/mini.pairs'),
    gh('kylechui/nvim-surround'),
    gh('catgoose/nvim-colorizer.lua'),
    gh('nvim-treesitter/nvim-treesitter'),
    gh('stevearc/conform.nvim'),
  },
  { confirm = false } -- 首次安装/断点续装时不弹确认框
)

-- conform.nvim：按需初始化（只做手动格式化，无启动依赖）
local ensure_conform = once(function()
  require('conform').setup({
    formatters_by_ft = {
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      lua = { 'stylua' },
      python = { 'ruff_format' },
      rust = { 'rustfmt', lsp_format = 'fallback' },
      -- json/jsonc 统一用 biome（Mason 已装）：一个工具覆盖两者，
      -- shell 数据处理仍用系统 jq（与编辑器无关）
      json = { 'biome' },
      jsonc = { 'biome' },
      ['*'] = { 'trim_whitespace' },
    },
    formatters = {
      biome = {
        args = { 'format', '--stdin-file-path', '$FILENAME', '--indent-style', 'space', '--indent-width', '2' },
      },
    },
  })
end)

-- mini.pairs
require('mini.pairs').setup({
  modes = { insert = true, command = true, terminal = false },
})

-- nvim-surround
require('nvim-surround').setup({})

-- nvim-colorizer.lua
require('colorizer').setup({})

-- treesitter
-- 有 parser 的文件类型自动启用原生高亮（无 parser 时静默跳过）
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})

-- conform.nvim
vim.keymap.set({ 'n', 'v' }, '<M-f>', function()
  ensure_conform()
  require('conform').format()
end, { desc = 'Conform: format buffer' })
