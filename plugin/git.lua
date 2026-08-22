--- Git：gitsigns.nvim（bufline 上的 git 符号/行内 blame）

local function gh(repo)
  return 'https://github.com/' .. repo
end

vim.pack.add(
  {
    gh('lewis6991/gitsigns.nvim'),
  },
  { confirm = false } -- 首次安装/断点续装时不弹确认框
)

require('gitsigns').setup({
  signs = {
    add = { text = '┃' },
    change = { text = '┃' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '┃' },
  },
  current_line_blame = true,
})
