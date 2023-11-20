local plugins = {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {}
    },
  },
  {
    "mfussenegger/nvim-dap",
    config = function(_, _)
      require("core.utils").load_mappings("dap")
    end
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "VeryLazy",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "clang-format",
        "codelldb",
      }
    }
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      'rcarriga/nvim-notify'
    },
    enabled = true,
    config = function ()
		local rounded_border_style = {
			top_left    = "╭", top    = "─",    top_right = "╮",
			left        = "│",                      right = "│",
			bottom_left = "╰", bottom = "─", bottom_right = "╯",
		}
		require("noice").setup({
      popupmenu = {
				enabled = true, -- enables the Noice popupmenu UI
				---@type 'nui'|'cmp'
				backend = "cmp", -- backend to use to show regular cmdline completions
				-- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
				kind_icons = {}, -- set to `false` to disable icons
			},
			-- default options for require('noice').redirect
			-- see the section on Command Redirection
			redirect = {
				view = "popup",
				filter = { event = "msg_show" },
			},
      notify = {
				-- Noice can be used as `vim.notify` so you can route any notification like other messages
				-- Notification messages have their level and other properties set.
				-- event is always "notify" and kind can be any log level as a string
				-- The default routes will forward notifications to nvim-notify
				-- Benefit of using Noice for this is the routing and consistent history view
				enabled = true,
				view = "notify",
			},
			lsp = {
				progress = {
					enabled = true,
					-- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
					-- See the section on formatting for more details on how to customize.
					--- @type NoiceFormat|string
					format = "lsp_progress",
					--- @type NoiceFormat|string
					format_done = "lsp_progress_done",
					throttle = 1000 / 30, -- frequency to update lsp progress message
					view = "mini",
				},
				override = {
					-- override the default lsp markdown formatter with Noice
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					-- override the lsp markdown formatter with Noice
					["vim.lsp.util.stylize_markdown"] = true,
					-- override cmp documentation with Noice (needs the other options to work)
					["cmp.entry.get_documentation"] = false,
				},
				hover = {
					enabled = false,
				},
				signature = {
					enabled = false,
				},
				message = {
					-- Messages shown by lsp servers
					enabled = true,
					view = "notify",
					opts = {},
				},
			},
			markdown = {
				hover = {
					["|(%S-)|"] = vim.cmd.help, -- vim help links
					["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
				},
				highlights = {
					["|%S-|"] = "@text.reference",
					["@%S+"] = "@parameter",
					["^%s*(Parameters:)"] = "@text.title",
					["^%s*(Return:)"] = "@text.title",
					["^%s*(See also:)"] = "@text.title",
					["{%S-}"] = "@parameter",
				},
			},
			health = {
				checker = true, -- Disable if you don't want health checks to run
			},
			smart_move = {
				-- noice tries to move out of the way of existing floating windows.
				enabled = true, -- you can disable this behaviour here
				-- add any filetypes here, that shouldn't trigger smart move.
				excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
			},
			---@type NoicePresets
			presets = {
				-- you can enable a preset by setting it to true, or a table that will override the preset config
				-- you can also add custom presets that you can enable/disable with enabled=true
				bottom_search = false, -- use a classic bottom cmdline for search
				command_palette = false, -- position the cmdline and popupmenu together
				long_message_to_split = false, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
			throttle = 1000 / 30, -- how frequently does Noice need to check for ui updates? This has no effect when in blocking mode.
			---@type NoiceConfigViews
			views = {
				cmdline_popup = {
					position = {
						row = 5,
						col = "50%",
					},
					size = {
						width = 60,
						height = "auto",
					},
					border = {
						style = rounded_border_style
					}
				},
				notify = {
					size = {
						width = 30
					},
          border = {
            style = rounded_border_style
          }
				},
				popupmenu = {
					relative = "editor",
					position = {
						row = 8,
						col = "50%",
					},
					size = {
						width = 60,
						height = 10,
					},
					border = {
						style = rounded_border_style,
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
					},
				},
			}, ---@see section on views
			---@type NoiceRouteConfig[]
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "search_count",
					},
					opts = { skip = true },
				},
			}, --- @see section on routes
		})

		vim.notify = require("notify")

		require("notify").setup({
			background_colour = "Normal",
			fps = 120,
			icons = {
				DEBUG = " ",
				ERROR = " ",
				INFO = " ",
				TRACE = "✎",
				WARN = " "
			},
			level = 2,
			minimum_width = 50,
			maximum_width = 50,
			render = "default",
			stages = "slide",
			timeout = 3000
		})
    end,
  },
  {
    "MunifTanjim/nui.nvim"
  },
  {
    "rcarriga/nvim-notify"
  },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
    },
  },
  {
    "nvim-lua/plenary.nvim"
  }
}
return plugins
