return {
	"hkupty/iron.nvim",
	keys = {
		{ "<space>rr", desc = "Toggle REPL" },
		{ "<space>sl", desc = "Send line to REPL" },
		{ "<space>sc", desc = "Send selection/motion to REPL", mode = { "n", "v" } },
		{ "<space>sf", desc = "Send file to REPL" },
	},
	config = function()
		local iron = require("iron.core")
		local common = require("iron.fts.common")

		-- Walk up from `dir` looking for a virtualenv's bin directory.
		local function find_venv_bin(dir)
			local path = dir
			while path and path ~= "" do
				for _, name in ipairs({ ".venv", "venv" }) do
					local bin = path .. "/" .. name .. "/bin"
					if vim.fn.executable(bin .. "/python3") == 1 then
						return bin
					end
				end
				local parent = vim.fn.fnamemodify(path, ":h")
				if parent == path then
					break
				end
				path = parent
			end
			return nil
		end

		-- Walk up from `dir` looking for the file that identifies the build
		-- tool of an enclosing Haskell project.
		local function find_haskell_build_tool(dir)
			local path = dir
			while path and path ~= "" do
				if vim.fn.filereadable(path .. "/stack.yaml") == 1 then
					return "stack"
				end
				if vim.fn.filereadable(path .. "/cabal.project") == 1 or vim.fn.glob(path .. "/*.cabal") ~= "" then
					return "cabal"
				end
				local parent = vim.fn.fnamemodify(path, ":h")
				if parent == path then
					break
				end
				path = parent
			end
			return nil
		end

		iron.setup({
			config = {
				repl_definition = {
					haskell = {
						-- Bare `ghci` only sees the global package db, so prefer the
						-- project's own REPL: that puts the package's modules and its
						-- dependencies in scope. iron's built-in haskell definitions
						-- would pick one of stack/cabal/ghci arbitrarily (it iterates
						-- them with pairs), hence choosing explicitly here.
						command = function(meta)
							local bufnr = meta.current_bufnr or meta.current_buffer or vim.api.nvim_get_current_buf()
							local filepath = vim.api.nvim_buf_get_name(bufnr)
							local dir = filepath ~= "" and vim.fn.fnamemodify(filepath, ":p:h") or vim.fn.getcwd()
							local build_tool = find_haskell_build_tool(dir)

							if build_tool == "stack" then
								return { "stack", "ghci" }
							elseif build_tool == "cabal" then
								return { "cabal", "repl" }
							end
							return { "ghci" }
						end,
						-- GHCi treats each line as its own input, so a multi-line
						-- binding sent line by line fails to parse. `:{`/`:}` makes it
						-- read the whole block as one unit.
						open = ":{",
						close = ":}",
					},
					python = {
						-- Prefer the project's venv, and prefer ipython within it: the
						-- plain REPL's CR-insertion heuristic for multi-line/nested
						-- blocks is fragile (it only tracks whether *any* earlier line
						-- was indented, not real nesting depth), so cells with nested
						-- blocks can get executed piecemeal. ipython's own multi-line
						-- handling is far more robust.
						command = function(meta)
							local bufnr = meta.current_bufnr or meta.current_buffer or vim.api.nvim_get_current_buf()
							local filepath = vim.api.nvim_buf_get_name(bufnr)
							local dir = filepath ~= "" and vim.fn.fnamemodify(filepath, ":p:h") or vim.fn.getcwd()
							local bin = find_venv_bin(dir)

							if bin then
								if vim.fn.executable(bin .. "/ipython") == 1 then
									return { bin .. "/ipython", "--no-autoindent" }
								end
								return { bin .. "/python3" }
							end

							if vim.fn.executable("ipython") == 1 then
								return { "ipython", "--no-autoindent" }
							end
							return { "python3" }
						end,
						format = common.bracketed_paste_python,
						env = { PYTHON_BASIC_REPL = "1" },
					},
				},
				repl_open_cmd = require("iron.view").right("40%"),
			},
			keymaps = {
				toggle_repl = "<space>rr",
				send_line = "<space>sl",
				visual_send = "<space>sc",
				send_motion = "<space>sc",
				send_file = "<space>sf",
			},
			highlight = { italic = true },
			ignore_blank_lines = true,
		})
	end,
}
