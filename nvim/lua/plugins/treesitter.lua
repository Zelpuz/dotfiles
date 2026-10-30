return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({ "python", "haskell", "lua", "vim", "vimdoc", "markdown", "query" })

		vim.api.nvim_create_autocmd("FileType", {
			-- Cabal files are deliberately absent: there's no tree-sitter
			-- parser for them, but Neovim ships a regex syntax file.
			pattern = { "python", "haskell", "lua", "vim", "vimdoc", "markdown", "query" },
			callback = function()
				vim.treesitter.start()
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			end,
		})
	end,
}
