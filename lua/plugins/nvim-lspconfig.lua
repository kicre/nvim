return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "saghen/blink.cmp" },

	config = function()
		vim.lsp.enable({ "lua_language_server", "ruff" })
	end,
}
