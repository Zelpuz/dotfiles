-- Clojure buffer settings.
--
-- Editing/evaluation lives in lua/plugins/clojure.lua (Conjure +
-- nvim-paredit). This file is the per-buffer bits: LSP and indentation.

-- Two-space indentation is universal in Clojure; there is no dissenting
-- style. cljfmt and clojure-lsp both assume it.
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.tabstop = 2
vim.bo.expandtab = true

-- Treat these as part of a word so that `w`, `*` and `K` behave sensibly
-- on Clojure identifiers: kebab-case names, namespaced keywords, and the
-- ?/! suffix convention (seq?, swap!, ->>).
vim.opt_local.iskeyword:append({ "-", "*", "+", "!", "?", "<", ">", "=", "/" })

-- Neovim 0.11+ has native LSP config, so no nvim-lspconfig needed.
-- clojure-lsp reads the code STATICALLY: rename across files, find
-- references, unused-var diagnostics, all without a running REPL.
-- Conjure talks to the LIVE process. They answer different questions and
-- you want both -- when they disagree, Conjure is right about the running
-- system and clojure-lsp is right about the files on disk.
if vim.fn.executable("clojure-lsp") == 1 then
	vim.lsp.config("clojure_lsp", {
		cmd = { "clojure-lsp" },
		filetypes = { "clojure" },
		root_markers = { "deps.edn", "project.clj", "bb.edn", ".git" },
	})
	vim.lsp.enable("clojure_lsp")
end

-- REPL eval shortcuts. Terminal.app can't tell Cmd/Option/Ctrl+Enter apart
-- from a plain <CR> -- they all arrive as the same byte. Kitty implements
-- the kitty keyboard protocol and Neovim negotiates it automatically
-- (TERM=xterm-kitty), so each of these arrives as its own distinct key
-- event once you're running inside kitty. Nothing else to configure.
--
-- Mirrors Calva's (VS Code) convention, since that's the mapping most
-- Clojure devs already have muscle memory for: Cmd/Ctrl+Enter evaluates
-- the innermost form under the cursor, Option+Enter the top-level form.
for _, spec in ipairs({
	{ "<D-CR>", "ConjureEvalCurrentForm" },
	{ "<C-CR>", "ConjureEvalCurrentForm" },
	{ "<M-CR>", "ConjureEvalRootForm" },
}) do
	local lhs, cmd = spec[1], spec[2]
	vim.keymap.set({ "n", "i" }, lhs, function()
		vim.cmd(cmd)
	end, { buffer = true, silent = true, desc = cmd })
end
