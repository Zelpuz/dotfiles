return {
	"mrcjkb/haskell-tools.nvim",
	version = "^10",
	-- The plugin registers its own filetype hooks and starts HLS from them,
	-- so it must not be lazy-loaded by lazy.nvim.
	lazy = false,
	init = function()
		-- haskell-tools has no setup() function: it reads vim.g.haskell_tools,
		-- which therefore has to be set before the plugin initialises.
		vim.g.haskell_tools = {
			tools = {
				-- iron.nvim drives the GHCi REPL, using the same keymaps as the
				-- Python setup, so haskell-tools' own REPL stays out of the way.
				repl = { auto_focus = false },
			},
			hls = {
				-- ghcup's wrapper picks the HLS build matching each project's
				-- GHC, which is what the default cmd already invokes.
				on_attach = function(_, bufnr)
					local ht = require("haskell-tools")
					local function map(lhs, rhs, desc)
						vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
					end

					map("<space>hc", vim.lsp.codelens.run, "Run code lens")
					map("<space>he", ht.lsp.buf_eval_all, "Evaluate all code snippets")
					map("<space>hs", ht.hoogle.hoogle_signature, "Hoogle signature search")
					map("<space>hf", function()
						vim.lsp.buf.format({ async = true })
					end, "Format buffer")
				end,
			},
		}
	end,
}
