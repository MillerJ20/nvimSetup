local M = {}

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
