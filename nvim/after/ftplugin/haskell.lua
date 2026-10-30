-- Ormolu, the formatter haskell-language-server runs by default, emits
-- two-space indentation, so match it rather than inheriting the global four.
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.tabstop = 2
vim.bo.expandtab = true

-- Neovim ships no indent script for Haskell and tree-sitter-haskell has no
-- indents query, so indentation is autoindent only: `>>`/`<<` and the layout
-- rule do the rest.
