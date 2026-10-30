-- Clojure editing for Neovim.
--
-- Copy to ~/.config/nvim/lua/plugins/clojure.lua
--
-- REQUIRES ONE CHANGE IN init.lua:
--
--     vim.g.maplocalleader = ","    -- was " "
--
-- Nothing in the current config uses <localleader> (it is set to " " in
-- init.lua and then never referenced), so this is a free change. It is
-- necessary because Conjure hangs everything off <localleader>, and with
-- localleader == mapleader == <space> its defaults land exactly on top of
-- iron.nvim's:
--
--     <space>rr   iron: toggle REPL      vs  conjure: refresh_changed
--     <space>sl   iron: send line        vs  conjure: session_list
--     <space>sc   iron: send selection   vs  conjure: session_clone
--     <space>sf   iron: send file        vs  conjure: session_fresh
--
-- All four collide. Conjure's maps are buffer-local so they would win
-- inside .clj buffers, which means the collision would not break anything
-- outright -- it would just silently do the wrong thing, which is worse.
-- With localleader as "," Clojure lives at ,ee / ,eb / ,lv and iron keeps
-- the whole <space> namespace for Python and Haskell.

return {
	{
		"Olical/conjure",
		-- Only for Clojure here. Conjure also supports Fennel, Janet,
		-- Racket, Scheme, Hy, Lua, Python and others; if you ever want it
		-- for those, widen this and drop the corresponding iron config.
		ft = { "clojure" },
		init = function()
			-- Conjure reads vim.g at load time rather than exposing a
			-- setup() function, so these must be set in init, not config.

			-- Do not create a scratch buffer on startup; this project always
			-- opens real files.
			vim.g["conjure#filetype#clojure"] = "conjure.client.clojure.nrepl"
			vim.g["conjure#extract#tree_sitter#enabled"] = true

			-- The HUD is the floating window that shows evaluation results.
			-- Anchored bottom-right, and it closes as soon as you move --
			-- the log buffer (,lv) is the durable record.
			vim.g["conjure#log#hud#enabled"] = true
			vim.g["conjure#log#hud#anchor"] = "SE"
			vim.g["conjure#log#hud#width"] = 0.6

			-- Wrap long results in the log rather than truncating them.
			-- Time series values are wide; you want to see them.
			vim.g["conjure#log#wrap"] = true

			-- Auto-start a REPL if none is running when you first evaluate.
			-- Off by default here: this project's REPL wants the :dev alias,
			-- and an auto-started bare REPL would silently give you a
			-- classpath without dev/ or test/ on it. Start it yourself with
			--     clj -M:dev:nrepl
			-- and Conjure will find it via .nrepl-port.
			vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false

			-- Evaluating a form that shadows a running definition is normal
			-- and expected in REPL-driven work; do not warn about it.
			vim.g["conjure#client#clojure#nrepl#eval#auto_require"] = true

			-- Test runner integration: ,tc runs the test under the cursor,
			-- ,tn the namespace's tests, ,ta everything.
			vim.g["conjure#client#clojure#nrepl#test#runner"] = "clojure"
		end,
	},

	{
		-- Structural editing. Clojure source is a tree, and editing it as
		-- flat text fights the language: you spend your attention on
		-- balancing parens instead of on the code. paredit-style commands
		-- move brackets around the tree instead.
		--
		-- The two that earn their keep immediately:
		--   >)  slurp forward  -- pull the next form INTO the current one
		--   <)  barf forward   -- push the last form OUT of the current one
		--
		-- Typing (map inc) then slurping the following collection in is the
		-- normal way to build a form. Expect about a week of friction.
		"julienvincent/nvim-paredit",
		ft = { "clojure" },
		config = function()
			require("nvim-paredit").setup({
				-- The defaults already bind everything below; they are listed
				-- here as documentation rather than configured. Note the `keys`
				-- table takes FUNCTION REFERENCES (api.slurp_forwards), not
				-- strings, and the operation names are plural -- passing
				-- "slurp_forward" fails at startup.
				--
				--   >)   slurp forwards    <)   barf forwards
				--   <(   slurp backwards   >(   barf backwards
				--   >e / <e   drag element right / left
				--   >f / <f   drag form right / left
				--   ,o   raise form        ,O   raise element
				--   ,@   splice (remove the surrounding brackets)
				--   W / E / B   motion by element head / tail / prev head
				use_default_keys = true,

				-- "auto" keeps the cursor where you would expect after a
				-- structural edit rather than following the moved form.
				cursor_behaviour = "auto",

				indent = { enabled = true },
			})
		end,
	},
}
