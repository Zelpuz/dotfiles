local o = vim.opt

o.number = true
o.relativenumber = true
o.mouse = "a"
o.clipboard = "unnamedplus"
o.breakindent = true
o.undofile = true
o.ignorecase = true
o.smartcase = true
o.signcolumn = "yes"
o.updatetime = 250
-- Apple's Terminal.app doesn't support 24-bit truecolor, so gui-only
-- highlight colors render as no highlight at all. Fall back to the
-- 256-color palette there; use truecolor everywhere else.
o.termguicolors = os.getenv("TERM_PROGRAM") ~= "Apple_Terminal"
o.splitright = true
o.splitbelow = true
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
-- Let left/right movement (arrow keys and h/l) wrap across line boundaries,
-- like most non-modal editors.
o.whichwrap = "b,s,<,>,[,],h,l"

-- Vim's built-in Python indent script indents a line after an unclosed
-- open paren/bracket/brace by 2x shiftwidth by default, to visually
-- distinguish it from a nested block at the same depth. One shiftwidth
-- is preferred here instead.
vim.g.pyindent_open_paren = "shiftwidth()"
