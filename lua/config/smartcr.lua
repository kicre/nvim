local M = {}

-- 把按键重新灌入输入流，mode 'n' 表示不再走映射（避免递归触发本回调）
local function feed(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', false)
end

-- 换行后先用 <C-u> 清掉 autoindent/smartindent 产生的缩进，再写入确定缩进
local function cr_then(prefix)
  feed('<C-g>u<CR><C-u>' .. prefix)
end

local function yaml_cr(line, col)
  local indent, rest = line:match('^(%s*)%- (.*)$')
  if not indent then return false end
  -- 光标还没越过 "- " 标记：普通换行
  if col < #indent + 2 then return false end
  -- 空列表项：清掉标记退出列表。注意本回调运行在 <expr> 映射内，不能直接
  -- 改 buffer（nvim_buf_set_text 会静默失败/报错），只能灌键；<C-u> 删掉
  -- 本次插入会话敲入的行内文本（'-' 与缩进）。
  if rest:match('^%s*$') then
    feed('<C-g>u<C-u>')
    return true
  end
  cr_then(indent .. '- ')
  return true
end

-- 成员行判定（Lua patterns 没有 | 分支，逐类显式判断）：
--   带尾逗号   : "key": <任意>,          → 直接续下一个成员
--   末成员     : "key": "str"|42|true…  → 续行前先补逗号
local key_prefix = '^%s*"[^"]+"%s*:%s*'

local function is_plain_member(line)
  local pm = line:match(key_prefix)
  if not pm then return false end
  local val = line:sub(#pm + 1):match('^(.-)%s*$')
  if val == '' then return false end
  return val:match('^".*"$') ~= nil -- string
    or tonumber(val) ~= nil -- number
    or val == 'true' or val == 'false' or val == 'null'
end

local function json_cr(line, col)
  -- 只在行尾续行，避免拆分字符串字面量
  if col < #line then return false end
  local has_comma = line:match(',%s*$') ~= nil
  if not (has_comma and line:match('^%s*"[^"]+"%s*:%s*.-,%s*$') or (not has_comma and is_plain_member(line))) then
    return false
  end
  local indent = line:match('^%s*')
  -- 上一行缺尾逗号则在换行前补上（json 对象成员必须逗号分隔）
  local comma = has_comma and '' or ','
  feed('<C-g>u' .. comma .. '<CR><C-u>' .. indent .. '""<C-g>U<Left>')
  return true
end

--- blink <CR> keymap 回调：true = 已处理；false = 交回 blink 走 accept/fallback
function M.on_cr(cmp)
  if cmp.is_menu_visible() then return cmp.accept() end
  local ok = false
  local ft = vim.bo.filetype
  if ft == 'yaml' or ft == 'json' or ft == 'jsonc' then
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    if ft == 'yaml' then
      ok = yaml_cr(line, col)
    else
      ok = json_cr(line, col)
    end
  end
  if ok then return true end
  return cmp.accept() -- 菜单未显示时返回 false，让 blink 继续 fallback
end

return M
