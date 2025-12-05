return {
  "lewis6991/gitsigns.nvim",
  event = "User FilePost",
  opts = {
    signs = {
      add = { text = "┃" },
      change = { text = "┃" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┃" },
    },
    current_line_blame = true,
  },
  keys = { }
}
