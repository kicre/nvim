-- 基础选项：参考 wsdjeg 的 Neovim 配置管理最佳实践整理
-- 提示：`:h <option>` 可查看每个选项的含义

local opt = vim.opt

-- 通用 ---------------------------------------------------------------
opt.clipboard = 'unnamedplus'          -- 使用系统剪贴板
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.mouse = 'a'                        -- 允许鼠标

-- 撤销持久化：重启 Neovim 后仍可 undo（文件存于 stdpath('data')/undo）
opt.undofile = true
opt.undolevels = 1000

-- 折叠（Treesitter expr fold 需要较新版本；旧版回退到 indent）
if vim.treesitter and vim.treesitter.foldexpr then
  opt.foldmethod = 'expr'
  opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
else
  opt.foldmethod = 'indent'
  opt.foldexpr = 'indent'
end
opt.foldlevel = 99

-- 缩进 / Tab ---------------------------------------------------------
opt.smarttab = true
opt.smartindent = true
opt.autoindent = true

opt.tabstop = 2          -- 一个 Tab 显示的视觉空格数
opt.softtabstop = 2      -- 编辑时按 Tab 前进的空格数
opt.shiftwidth = 2       -- 缩进步长
opt.expandtab = true     -- Tab 展开为空格（Python 等场景）

-- 界面 ---------------------------------------------------------------
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = 'yes'   -- 始终保留 sign column，避免诊断/符号出现时跳动
opt.scrolloff = 8        -- 上下滚动时保留 8 行上下文
opt.sidescrolloff = 8    -- 左右滚动时保留 8 列上下文
opt.splitbelow = true    -- 新窗口默认在下方
opt.splitright = true    -- 新纵向窗口默认在右侧
pcall(function() opt.splitkeep = 'screen' end) -- 分割/删除窗口时尽量保持视图不滚动
opt.termguicolors = true -- 启用 24-bit 颜色
opt.showmode = false     -- 状态栏已足够，不再显示 -- INSERT --
opt.laststatus = 3       -- 全局状态栏
pcall(function() opt.winborder = 'rounded' end) -- 较新版本才有圆角边框
opt.showtabline = 1      -- 仅多于 1 个 tab 时显示（无 tabline 插件，=2 会常驻空栏）

-- 响应速度 -------------------------------------------------------------
opt.updatetime = 200     -- CursorHold 触发更快（gitsigns blame / 诊断浮窗）
opt.timeoutlen = 400     -- 操作符/键位序列等待（which-key 弹窗节奏）
opt.inccommand = 'split' -- :%s 替换实时预览（下方分割预览窗）

-- 诊断 -----------------------------------------------------------------
pcall(function()
  vim.diagnostic.config({
    virtual_text = true,     -- 行内显示诊断文本
    signs = true,            -- sign column 显示图标
    underline = true,        -- 出错处下划线
    severity_sort = true,    -- 按严重程度排序
    float = { source = 'if_many' }, -- 浮窗显示来源（多项时）
  })
end)

-- 搜索 ---------------------------------------------------------------
opt.incsearch = true
opt.hlsearch = true      -- 搜索后保留高亮，用 <Esc> 快速清除
opt.ignorecase = true
opt.smartcase = true
