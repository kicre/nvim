--- vim.pack 全局管理命令。
--- 只放命令，不声明清单；各插件清单在其类别文件顶部就近声明。

vim.api.nvim_create_user_command('PackUpdate', function(args)
  local names = vim.split(args.args or '', '%s+', { trimempty = true })
  vim.pack.update(#names > 0 and names or nil)
end, { nargs = '*', desc = 'Update plugins managed by vim.pack' })

vim.api.nvim_create_user_command('PackDelete', function(args)
  vim.pack.del(vim.split(args.args, '%s+', { trimempty = true }))
end, { nargs = '+', desc = 'Delete plugins from disk (vim.pack)' })

vim.api.nvim_create_user_command('PackInfo', function()
  local lines = vim.iter(vim.pack.get())
    :map(function(p)
      return ('%s %s %s'):format(p.active and '•' or ' ', p.rev:sub(1, 8), p.spec.name)
    end)
    :totable()
  table.sort(lines)
  vim.cmd('new')
  vim.bo[vim.api.nvim_get_current_buf()].filetype = 'packinfo'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.cmd('setlocal buftype=nofile bufhidden=wipe')
end, { desc = 'List plugins managed by vim.pack' })
