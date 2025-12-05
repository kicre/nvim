return {
	"navarasu/onedark.nvim",
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		require("onedark").setup({
			style = "light",
			transparent = true,
			colors = {
				black = "#181b1f",
				bg0 = "#FFFDFB",
				bg1 = "#ededed",
				bg2 = "#F0F0F0",
				bg3 = "#e6e6e6",
				bg_d = "#CECECE",
				fg = "#3E4044",
				red = "#ca7081",
				orange = "#c27d40",
				yellow = "#92963a",
				green = "#3ea57b",
				cyan = "#00a0ba",
				blue = "#6e8dd5",
				purple = "#ac78bd",
				grey = "#AEAEAE",
				light_grey = "#636363",
				dark_red = "#18A4C1",
				dark_yellow = "#D6D25A",
				dark_cyan = "#2CE600",
				dark_purple = "#ECB00F",
			},
		})
		require("onedark").load()
	end,
}
