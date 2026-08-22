# Neovim 配置

插件管理保留 Neovim 0.12 内置 `vim.pack`，不引入额外插件管理器。

## 目录结构

```text
~/.config/nvim/
├── after/
│   └── lsp/
│       └── lua_ls.lua       # lua_ls 官方推荐配置（覆盖 nvim-lspconfig 默认值）
├── init.lua                 # 极简入口：leader + 选项 + 键位（不含插件）
├── plugin/                  # Neovim 启动时按文件名顺序自动 source，天然模块化
│   ├── chezmoi.lua          # 清单+配置：chezmoi（整体按需）
│   ├── editor.lua           # 清单+配置：pairs/surround/colorizer/treesitter(含 TSUpdate 钩子) + conform(按需)
│   ├── git.lua              # 清单+配置：gitsigns
│   ├── ime.lua              # 输入法自动切换（rime-ctl，异步）
│   ├── lsp.lua              # 清单+配置：mason(仅安装)/lspconfig/blink
│   ├── pack.lua             # vim.pack 管理命令（:PackUpdate / :PackDelete / :PackInfo）
│   └── ui.lua               # 清单+配置：transparent/lualine/which-key/snacks/配色 + neotree/trouble(按需)
├── colors/
│   └── penumbra.lua         # Penumbra 配色（标准 colors/ 目录，供 :colorscheme 查找）
├── lua/
│   └── config/
│       ├── options.lua      # 全局选项 + 诊断样式
│       ├── keymaps.lua      # 全局快捷键（均带 desc）
│       └── smartcr.lua      # json/yaml 智能回车续行（挂在 blink <CR> 回调）
└── nvim-pack-lock.json      # 插件版本锁（建议提交到 VCS）
```

> 插件配置直接写在顶层 `plugin/` 目录：Neovim 会在启动时（init.lua 之后）
> 按文件名顺序自动 source 其中的 `*.lua`，无需在 init.lua 里手动 require。
> 不做数字前缀，文件按字母序自动加载；每个文件自包含，若有强制顺序需求
> 再在 init.lua 里显式 require。每个类别文件顶部用 `vim.pack.add` 就近声明
> 本类别插件清单；由于这些文件在启动阶段被 source，`vim.pack.add` 会自动
> 把插件加入 runtimepath，随后直接 `require().setup()`；`pack.lua` 只留全局
> 管理命令。
>
> 主题按标准方式放在 `colors/penumbra.lua`，`plugin/ui.lua` 直接执行
> `:colorscheme penumbra` 即可；`g:colors_name`、background 联动、
> transparent 重放等原生机制全部保留。配色与 transparent 同文件且在其后，
> 先后顺序由代码位置保证。

## 常用命令

| 命令 / 键位 | 作用 |
| --- | --- |
| `:PackUpdate` | 更新全部由 vim.pack 管理的插件 |
| `:PackUpdate name` | 更新指定插件 |
| `:PackDelete name` | 从磁盘删除指定插件 |
| `:PackInfo` | 查看已安装/已加载插件 |
| `<leader>w` / `<leader>q` | 保存 / 退出 |
| `<Space>ff` / `<Space>fg` / `<Space>fr` | 查找文件 / 全文搜索 / 最近文件 |
| `<leader>?` | which-key 查看当前 buffer 的局部键位 |
| 按 `<leader>` 后稍等 | which-key 自动弹出可用键位 |
| `:PenumbraDark` / `:PenumbraLight` | 手动切换 Penumbra 深浅主题 |

## LSP 说明

- `mason.nvim` 负责安装语言服务器二进制。
- 安装这些服务器：
  `:MasonInstall yaml-language-server vscode-json-language-server taplo lua-language-server pyright ruff typescript-language-server bash-language-server`
- `plugin/lsp.lua` 中维护了一个 `mason_to_lsp` 映射，会自动启用已经通过
- 服务器自定义配置按官方推荐放在 `after/lsp/<server>.lua`，用来覆盖
  `nvim-lspconfig` 提供的默认配置。
- 如果以后需要覆盖所有 Mason LSP 包名映射，也可以换回
  `mason-lspconfig.nvim` 的 `automatic_enable = true`。

## 维护约定

- 新增插件：直接在对应类别文件（editor / ui / lsp / git / chezmoi）顶部的
  `vim.pack.add` 清单里声明，并在同文件直接 `require().setup()`。跨类别依赖
  （如 plenary）可在多个文件重复声明，`vim.pack.add` 幂等。全新类别直接新建
  `plugin/<category>.lua`，文件名即类别名。
- 插件加载顺序：因为使用字母序自动加载，不依赖数字前缀；同一文件内部靠代码
  顺序（transparent 的 setup 与配色同在 `ui.lua`，前者的调用必须写在文件末尾
  `:colorscheme` 之前）。依赖安装/更新的 `PackChanged` 钩子必须注册在所在文件
  的 `vim.pack.add` 之前。
- 按需初始化：启动就需要配置的插件直接 `require().setup()`；仅触发式使用的插件
  （neo-tree/trouble/conform/chezmoi）用文件内局部 `once(fn)` 包一层，
  首次触发时才执行 setup。
- `plugin/*.lua` 是启动脚本（被 source），不是模块（不 return、不被 require）。
