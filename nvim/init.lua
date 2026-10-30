vim.g.mapleader = " "
-- Conjure hangs all of its Clojure mappings off <localleader>. With
-- localleader == mapleader == <space> its defaults collide exactly with
-- iron.nvim's: <space>rr, <space>sl, <space>sc and <space>sf are toggle
-- REPL / send line / send selection / send file for iron, and
-- refresh_changed / session_list / session_clone / session_fresh for
-- Conjure. Conjure's are buffer-local so they would silently win inside
-- .clj buffers rather than erroring.
--
-- Nothing else in this config uses <localleader>, so Clojure gets it.
-- Must stay above require("config.lazy"): lazy.nvim reads maplocalleader
-- when it loads and warns if it changes afterwards.
vim.g.maplocalleader = ","

require("config.options")
require("config.lazy")

vim.cmd.colorscheme("habamax")
