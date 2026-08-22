local function gh(repo)
  return 'https://github.com/' .. repo
end

vim.pack.add(
  {
    gh('neovim/nvim-lspconfig'),
    gh('mason-org/mason.nvim'),
    {
      src = gh('saghen/blink.cmp'),
      -- 锁定 1.* 系列：使用预编译二进制，无需 cargo 构建
      version = vim.version.range('1.*'),
    },
    gh('rafamadriz/friendly-snippets'),
  },
  { confirm = false } -- 首次安装/断点续装时不弹确认框
)

-- mason.nvim：LSP server 安装器（负责把二进制放进 Neovim 的 PATH）
require('mason').setup()

-- nvim-lspconfig：提供服务器配置
-- 自动启用已经通过 Mason 安装的 LSP（按 Mason 包名映射到 lspconfig 配置名）
local mason_dir = vim.fn.stdpath('data') .. '/mason/packages'

local mason_to_lsp = {
  ['lua-language-server'] = 'lua_ls',
  ['yaml-language-server'] = 'yamlls',
  ['vscode-json-language-server'] = 'jsonls',
  ['taplo'] = 'taplo',
  ['pyright'] = 'pyright',
  ['ruff'] = 'ruff',
  ['typescript-language-server'] = 'ts_ls',
  ['bash-language-server'] = 'bashls',
  ['texlab'] = 'texlab',
  ['tinymist'] = 'tinymist',
  ['biome'] = 'biome',
}

-- 只有 lspconfig 中存在同名配置时才启用，避免误启用非 LSP 包
if vim.fn.isdirectory(mason_dir) == 1 then
  for _, pkg in ipairs(vim.fn.readdir(mason_dir)) do
    local server = mason_to_lsp[pkg]
    if server and vim.lsp.config[server] then
      pcall(vim.lsp.enable, server)
    end
  end
end

-- blink.cmp
require('blink.cmp').setup({
  -- 'default' (recommended) for mappings similar to built-in completions
  -- (accept with C-y), 'super-tab' for vscode-style Tab, 'enter'/'none'...
  keymap = {
    preset = 'none',
    ['<A-j>'] = {
      function(cmp)
        return cmp.select_next({ auto_insert = false })
      end,
      'fallback',
    },
    ['<A-k>'] = {
      function(cmp)
        return cmp.select_prev({ auto_insert = false })
      end,
      'fallback',
    },
    ['<C-n>'] = {
      function(cmp)
        return cmp.select_next({ auto_insert = false })
      end,
      'fallback',
    },
    ['<C-p>'] = {
      function(cmp)
        return cmp.select_prev({ auto_insert = false })
      end,
      'fallback',
    },

    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },

    ['<Tab>'] = {
      function(cmp)
        return cmp.accept()
      end,
      'fallback',
    },
    ['<CR>'] = {
      -- 补全菜单可见时 accept；yaml/json 命中智能续行（config.smartcr）则消费；
      -- 其余情况 false → 'fallback'（原生 <CR>，仍会经过 MiniPairs 的成对展开）
      function(cmp)
        return require('config.smartcr').on_cr(cmp)
      end,
      'fallback',
    },
    -- Close current completion and insert a newline
    ['<S-CR>'] = {
      function(cmp)
        cmp.hide()
        return false
      end,
      'fallback',
    },

    -- Show/Remove completion
    ['<A-/>'] = {
      function(cmp)
        if cmp.is_menu_visible() then
          return cmp.hide()
        else
          return cmp.show()
        end
      end,
      'fallback',
    },

    ['<A-n>'] = {
      function(cmp)
        cmp.show({ providers = { 'buffer' } })
      end,
    },
    ['<A-p>'] = {
      function(cmp)
        cmp.show({ providers = { 'buffer' } })
      end,
    },
  },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    nerd_font_variant = 'mono',
  },

  -- (Default) Only show the documentation popup when manually triggered
  completion = {
    trigger = { show_on_trigger_character = true },
    documentation = { auto_show = true },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  fuzzy = { implementation = 'prefer_rust_with_warning' },
})
