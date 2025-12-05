return {
	"saecki/live-rename.nvim",
	opts = {},
	keys = {
		{
			"<M-r>",
			function()
				require("live-rename").rename({ insert = true })
			end,
		},
	},
}
