return {
	"stevearc/conform.nvim",
	cmd = "ConformInfo",
	opts = {
		formatters_by_ft = {
			c = { "clang-format" },
			cpp = { "clang-format" },
			lua = { "stylua" },
			python = { "ruff_format" },
			rust = { "rustfmt", lsp_format = "fallback" },
			["*"] = { "trim_whitespace" },
		},
	},
	keys = {
		{
			"<M-f>",
			function()
				require("conform").format()
			end,
			mode = { "n", "v" },
		},
	},
}
