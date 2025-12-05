return {
  "folke/trouble.nvim",
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
  },
  cmd = { "Trouble", "TroubleToggle" },
  opts = {},
  keys = {
    { "gr", "<CMD>Trouble lsp_references toggle<CR>" },
    { "gd", "<CMD>Trouble lsp_definitions toggle<CR>" },
    { "gi", "<CMD>Trouble lsp_implementations toggle<CR>" },
    { "<leader>xx", "<CMD>Trouble diagnostics toggle<CR>" },
    { "<leader>o", "<CMD>Trouble symbols toggle win.position=right<CR>" },
  },
}
