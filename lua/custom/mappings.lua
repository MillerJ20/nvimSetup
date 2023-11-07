local M = {}

M.general = {
  n = {
	  ["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
    ["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
    ["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
    ["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },
  }
}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add a breakpoint at line",
    },
    ["<leader>dr"] = {
      "<cmd> DapContinue <CR>",
      "Start or contnue the debugger",
    }
  }
}

M.todo = {
  plugin = true,
  n = {
    ["<leader>tq"] = {
      "<cmd> TodoQuickFix <CR>",
      "Show all todos in the project using quickfix list",
    }
  }
}

return M
