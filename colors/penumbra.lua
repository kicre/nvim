local variants = {
  dark = {
    bg = '#1E2227',
    fg = '#9A9A9A',
    comment = '#6B6B6B',
    red = '#F58C81',
    green = '#54C794',
    yellow = '#A9B852',
    blue = '#6EB2FD',
    magenta = '#E58CC5',
    cyan = '#00C4D7',
    control = '#B69CF6',
    constant = '#E09F47',
    attribute = '#8D9741',
    property = '#BA823A',
    field = '#00A0BE',
    macro = '#9481CC',
    special = '#7E87D6',
    namespace = '#7E87D6',
    label = '#8D9741',
    mid = '#9A9A9A',
    selection = '#F2E6D4',
    cursor = '#FFF7ED',
    gray = '#6B6B6B',
    panel = '#3F444C',
    white = '#D0D0D0',
    black = '#0F1216',
  },
  light = {
    bg = '#FFF7ED',
    fg = '#1F2328',
    comment = '#707070',
    red = '#A45B3F',
    green = '#2B835D',
    yellow = '#80721A',
    blue = '#6669AE',
    magenta = '#9A5884',
    cyan = '#007F9C',
    control = '#7367A4',
    constant = '#95662D',
    attribute = '#727731',
    property = '#95662D',
    field = '#007F9C',
    macro = '#7367A4',
    special = '#6669AE',
    namespace = '#6669AE',
    label = '#727731',
    mid = '#1F2328',
    selection = '#9A9A9A',
    cursor = '#343941',
    gray = '#707070',
    panel = '#F2E6D4',
    white = '#1F2328',
    black = '#F2E6D4',
  },
}

--- 应用指定变体的高亮组
local function apply(variant)
  local c = variants[variant] or variants.dark
  local light = (variant == 'light')

  local set = function(group, val)
    vim.api.nvim_set_hl(0, group, type(val) == 'table' and val or { fg = val })
  end
  local function pick(light_val, dark_val)
    return light and light_val or dark_val
  end
  -- OneLight / OneDark semantic role differences
  local keyword_fg = pick(c.control, c.red)
  local operator_fg = pick(c.red, c.control)
  local conditional_fg = pick(c.red, c.control)
  local repeat_fg = pick(c.magenta, c.control)
  local label_fg = pick(c.cyan, c.control)
  local special_fg = pick(c.control, c.blue)
  local member_fg = pick(c.magenta, c.red)
  local tag_fg = pick(c.cyan, c.red)

  set('Normal', { fg = c.fg, bg = c.bg })
  set('NormalFloat', { fg = c.fg, bg = c.panel })
  set('NormalNC', { fg = c.fg, bg = c.bg })
  set('Cursor', { fg = c.bg, bg = c.cursor })
  set('CursorLineNr', { fg = c.gray })
  set('Visual', { bg = c.selection })
  set('VisualNOS', { bg = c.selection })
  set('LineNr', { fg = c.gray })
  set('SignColumn', { fg = c.gray })
  set('StatusLine', { fg = c.fg, bg = c.panel })
  set('StatusLineNC', { fg = c.comment, bg = c.bg })
  set('WinSeparator', { fg = c.gray })
  set('Folded', { fg = c.comment, bg = c.bg })
  set('FoldColumn', { fg = c.gray })
  set('Pmenu', { fg = c.fg, bg = c.panel })
  set('PmenuSel', { fg = c.bg, bg = c.blue })
  set('Search', { bg = c.yellow })
  set('IncSearch', { bg = c.yellow })
  set('MatchParen', { fg = c.yellow, bold = true })
  set('Whitespace', { fg = c.comment })
  set('NonText', { fg = c.comment })
  set('Conceal', { fg = c.comment })
  set('Title', { fg = c.cyan, bold = true })
  set('Directory', { fg = c.cyan })
  set('ErrorMsg', { fg = c.red, bold = true })
  set('WarningMsg', { fg = c.yellow, bold = true })
  set('MoreMsg', { fg = c.green })
  set('Question', { fg = c.blue })
  set('TabLine', { fg = c.comment, bg = c.panel })
  set('TabLineSel', { fg = c.fg, bg = c.panel })
  set('FloatBorder', { fg = c.gray })
  set('FloatTitle', { fg = c.cyan })
  set('Bold', { bold = true })
  set('Italic', { italic = true })
  set('Underlined', { underline = true })
  set('DiagnosticUnderlineError', { underline = true })
  set('DiagnosticUnderlineWarn', { underline = true })
  set('Comment', { fg = c.comment, italic = true })
  set('Constant', { fg = c.cyan })
  set('String', { fg = c.green })
  set('Character', { fg = c.green })
  set('Number', { fg = c.constant })
  set('Boolean', { fg = c.constant })
  set('Float', { fg = c.constant })
  set('Identifier', { fg = c.fg })
  set('Function', { fg = c.blue })
  set('Statement', { fg = keyword_fg })
  set('Conditional', { fg = conditional_fg })
  set('Repeat', { fg = repeat_fg })
  set('Label', { fg = label_fg })
  set('Operator', { fg = operator_fg })
  set('Keyword', { fg = keyword_fg })
  set('Exception', { fg = keyword_fg })
  set('PreProc', { fg = c.macro })
  set('Include', { fg = c.macro })
  set('Define', { fg = c.macro })
  set('Macro', { fg = c.macro })
  set('Type', { fg = c.yellow })
  set('StorageClass', { fg = c.control })
  set('Structure', { fg = c.yellow })
  set('Typedef', { fg = c.yellow })
  set('Special', { fg = special_fg })
  set('Tag', { fg = tag_fg })
  set('Delimiter', { fg = c.mid })
  set('@comment', { fg = c.comment, italic = true })
  set('@string', { fg = c.green })
  set('@string.escape', { fg = c.cyan })
  set('@character', { fg = c.green })
  set('@number', { fg = c.constant })
  set('@boolean', { fg = c.constant })
  set('@float', { fg = c.constant })
  set('@function', { fg = c.blue })
  set('@function.call', { fg = c.blue })
  set('@function.macro', { fg = c.macro })
  set('@method', { fg = c.blue })
  set('@constructor', { fg = c.blue })
  set('@keyword', { fg = keyword_fg })
  set('@keyword.conditional', { fg = conditional_fg })
  set('@keyword.repeat', { fg = repeat_fg })
  set('@keyword.return', { fg = c.control })
  set('@keyword.function', { fg = keyword_fg })
  set('@keyword.operator', { fg = operator_fg })
  set('@keyword.type', { fg = c.yellow })
  set('@keyword.storage', { fg = c.control })
  set('@label', { fg = label_fg })
  set('@operator', { fg = operator_fg })
  set('@punctuation', { fg = c.mid })
  set('@punctuation.bracket', { fg = c.mid })
  set('@punctuation.delimiter', { fg = c.mid })
  set('@punctuation.special', { fg = special_fg })
  set('@type', { fg = c.yellow })
  set('@type.builtin', { fg = c.yellow })
  set('@type.definition', { fg = c.yellow })
  set('@type.qualifier', { fg = c.red })
  set('@variable', { fg = c.fg })
  set('@variable.builtin', { fg = c.red })
  set('@variable.parameter', { fg = c.red })
  set('@variable.member', { fg = member_fg })
  set('@property', { fg = c.property })
  set('@tag', { fg = tag_fg })
  set('@tag.attribute', { fg = c.attribute })
  set('@attribute', { fg = c.yellow })
  set('@special', { fg = special_fg })
  set('@namespace', { fg = c.namespace })
  set('@module', { fg = c.namespace })
  set('@constant', { fg = c.cyan })
  set('@constant.builtin', { fg = c.cyan })
  set('@constant.macro', { fg = c.macro })
  set('@struct', { fg = c.blue })
  set('@enum', { fg = c.blue })
  set('@enumMember', { fg = c.constant })
  set('@field', { fg = c.field })
  set('@parameter', { fg = c.red })
  set('@exception', { fg = keyword_fg })
  set('@macro', { fg = c.macro })
  set('@include', { fg = c.macro })
  set('@symbol', { fg = c.cyan })
  set('@conditional', { fg = conditional_fg })
  set('@repeat', { fg = repeat_fg })
  set('DiagnosticError', { fg = c.red })
  set('DiagnosticWarn', { fg = c.yellow })
  set('DiagnosticInfo', { fg = c.cyan })
  set('DiagnosticHint', { fg = c.comment })
  set('@lsp.type.class', { fg = c.yellow })
  set('@lsp.type.function', { fg = c.blue })
  set('@lsp.type.method', { fg = c.blue })
  set('@lsp.type.property', { fg = c.control })
  set('@lsp.type.variable', { fg = c.fg })
  set('@lsp.typemod.function.defaultLibrary', { fg = c.cyan })
  set('@lsp.type.enum', { fg = c.blue })
  set('@lsp.type.keyword', { fg = keyword_fg })
  set('@lsp.type.namespace', { fg = c.blue })
  set('@lsp.mod.static', { fg = c.blue, bold = true })
end

-- 应用当前变体（本文件由 :colorscheme penumbra 触发执行）
apply(vim.o.background == 'light' and 'light' or 'dark')
vim.g.colors_name = 'penumbra'

-- 切换命令：只改 background，重载由 Neovim 自动完成（background 变化时
-- 会重新执行 :colorscheme penumbra，即本文件）
vim.cmd([[command! PenumbraDark  set background=dark]])
vim.cmd([[command! PenumbraLight set background=light]])
