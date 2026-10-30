return {
	"GCBallesteros/NotebookNavigator.nvim",
	keys = {
		{
			"]h",
			function()
				require("notebook-navigator").move_cell("d")
			end,
			desc = "Next cell",
		},
		{
			"[h",
			function()
				require("notebook-navigator").move_cell("u")
			end,
			desc = "Previous cell",
		},
		{
			"<leader>X",
			function()
				require("notebook-navigator").run_cell()
			end,
			desc = "Run cell",
		},
		{
			"<leader>x",
			function()
				require("notebook-navigator").run_and_move()
			end,
			desc = "Run cell and move to next",
		},
	},
	dependencies = {
		"echasnovski/mini.comment",
		"hkupty/iron.nvim",
		"anuvyklack/hydra.nvim",
	},
	event = "VeryLazy",
	opts = {
		activate_hydra_keys = "<leader>h",
	},
}
