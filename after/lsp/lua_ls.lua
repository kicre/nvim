--- 官方推荐的 Lua LSP 配置，用于优化 Neovim 自身配置的补全/诊断。
--- 放在 after/lsp/ 中以覆盖 nvim-lspconfig 提供的默认 lua_ls 配置。

---@type vim.lsp.Config
return {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- 大多数情况下 Neovim 使用的是 LuaJIT
        version = 'LuaJIT',
        -- 让 LuaLS 能按 Neovim 的方式找到模块
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          vim.fn.stdpath('config'),
          -- nvim-lspconfig 的 LSP Settings 类型定义
          vim.api.nvim_get_runtime_file('lua/lspconfig', false)[1],
        },
      },
    })
  end,
  settings = {
    Lua = {},
  },
}
