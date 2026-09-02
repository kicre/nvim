--- 兼容层：无网络 / Neovim < 0.12 时自动进入最小配置模式。
---
--- 完整模式需要同时满足：
---   1. 当前 Neovim 提供内置 `vim.pack`（0.12+）；
---   2. 锁文件中的插件已经全部在磁盘上（避免启动时联网安装）；
---   3. 未通过 `NVIM_MINIMAL` 显式关闭；
---   若确实需要在线安装/更新插件，可设置 `NVIM_PACK_INSTALL=1` 绕过第 2 条。

local M = {}

local function plugin_dir()
  return vim.fn.stdpath('data') .. '/site/pack/core/opt'
end

--- 读取 vim.pack 锁文件中的插件名列表。
--- 锁文件缺失或损坏时返回 nil，此时不能安全地判断“已安装”，按未安装处理。
local function lock_plugin_names()
  local path = vim.fn.stdpath('config') .. '/nvim-pack-lock.json'
  if vim.fn.filereadable(path) ~= 1 then
    return nil
  end

  local ok, lock = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(path), '\n'))
  end)
  if not ok or type(lock) ~= 'table' or type(lock.plugins) ~= 'table' then
    return nil
  end

  local names = {}
  for name in pairs(lock.plugins) do
    names[#names + 1] = name
  end
  return names
end

--- 锁文件中声明的插件是否已全部在 vim.pack 目录中。
local function all_plugins_installed()
  local names = lock_plugin_names()
  if not names or #names == 0 then
    return false
  end

  local dir = plugin_dir()
  for _, name in ipairs(names) do
    local path = dir .. '/' .. name
    if vim.fn.isdirectory(path) ~= 1 then
      return false
    end
    -- vim.pack 使用 git 管理；无 .git 的目录视为未完整安装，避免启动时误联网修复
    local git = path .. '/.git'
    if vim.fn.isdirectory(git) ~= 1 and vim.fn.filereadable(git) ~= 1 then
      return false
    end
  end
  return true
end

--- 是否启用完整插件模式。
function M.is_full()
  -- 显式最小模式优先
  if vim.env.NVIM_MINIMAL and vim.env.NVIM_MINIMAL ~= '0' then
    return false
  end

  -- Neovim < 0.12 没有 vim.pack，无法进入完整插件模式
  if type(vim.pack) ~= 'table' then
    return false
  end

  -- 显式允许启动时安装/同步（需要网络）
  if vim.env.NVIM_PACK_INSTALL and vim.env.NVIM_PACK_INSTALL ~= '0' then
    return true
  end

  -- 无网络/未安装时不要触发联网安装，进入最小配置
  return all_plugins_installed()
end

--- 在 init.lua 顶部调用：设置最小模式标志，供插件脚本判断。
function M.setup()
  if M.is_full() then
    vim.g.nvim_minimal = false
    vim.g.nvim_minimal_reason = nil
    return true
  end

  vim.g.nvim_minimal = true
  -- 关闭 runtimepath 下所有 plugin/ 脚本加载，确保真正的最小配置。
  -- 这是 Neovim 原生机制，无需改动任何 plugin/*.lua。
  vim.o.loadplugins = false
  if type(vim.pack) ~= 'table' then
    vim.g.nvim_minimal_reason = 'Neovim < 0.12 (no vim.pack)'
  elseif vim.env.NVIM_MINIMAL and vim.env.NVIM_MINIMAL ~= '0' then
    vim.g.nvim_minimal_reason = 'NVIM_MINIMAL'
  else
    vim.g.nvim_minimal_reason = 'plugins not installed (offline/not bootstrapped)'
  end
  return false
end

--- 是否处于最小配置模式。
function M.is_minimal()
  return vim.g.nvim_minimal == true
end

return M
