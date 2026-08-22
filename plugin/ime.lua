--- Neovim 输入法控制
---
--- Linux/macOS：
---   - 进入插入模式   -> 恢复中文输入
---   - 退出插入模式   -> 保存状态并切回英文
---   - 启动 Neovim    -> 强制英文
---
--- Windows：
---   - 进入插入模式   -> 不切换输入法
---   - 退出插入模式   -> 切换英文/ASCII
---   - 启动 Neovim    -> 切换英文/ASCII
--- 由编辑器侧控制，不依赖小狼毫的 vim_mode。
---
--- 找不到对应控制脚本或输入法环境时自动忽略。

local is_windows = vim.fn.has('win32') == 1

local function find_script()
  if is_windows then
    local appdata = vim.fn.getenv('APPDATA')
    if appdata and appdata ~= vim.NIL then
      local path = appdata .. '\\helix\\rime-ctl.cmd'
      if vim.fn.filereadable(path) == 1 then
        return path
      end
    end
    return nil
  end

  local candidates = {
    vim.fn.expand('~/.config/scripts/rime-ctl.sh'),
  }

  for _, path in ipairs(candidates) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end

  return nil
end

local script = find_script()

local function run(action)
  if not script or not action then
    return
  end

  local cmd
  if is_windows then
    cmd = { 'cmd.exe', '/c', ('"%s" %s'):format(script, action) }
  else
    cmd = { script, action }
  end

  -- 异步执行，不阻塞按键（进出插入模式高频触发）
  vim.system(cmd, {}, function(res)
    if res.code ~= 0 then
      vim.schedule(function()
        vim.notify(('rime-ctl %s 失败（退出码 %d）'):format(action, res.code), vim.log.levels.WARN)
      end)
    end
  end)
end

local function setup()
  if not script then
    return
  end

  -- 启动时保证 normal 模式为英文
  vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
      run('start')
    end,
  })

  -- Windows：进入插入模式不切换输入法；只处理退出
  if not is_windows then
    vim.api.nvim_create_autocmd('InsertEnter', {
      callback = function()
        run('enter')
      end,
    })
  end

  -- 退出插入模式 / 回到 normal 模式时切英文
  vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
      run('exit')
    end,
  })
end

setup()
