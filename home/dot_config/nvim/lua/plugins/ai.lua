return {
  {
    "olimorris/codecompanion.nvim",
    init = function()
      -- This code adds noice adds notifications when in progress.
      -- I got this from:
      --   https://github.com/olimorris/codecompanion.nvim/discussions/813

      local Format = require("noice.text.format")
      local Message = require("noice.message")
      local Manager = require("noice.message.manager")
      local Router = require("noice.message.router")

      local ThrottleTime = 200
      local handles = {}

      local function store_progress_handle(id, handle)
        handles[id] = handle
      end

      local function pop_progress_message(id)
        local handle = handles[id]
        handles[id] = nil
        return handle
      end

      local function llm_role_title(adapter)
        local parts = {}
        table.insert(parts, adapter.formatted_name)
        if adapter.model and adapter.model ~= "" then
          table.insert(parts, "(" .. adapter.model .. ")")
        end
        return table.concat(parts, " ")
      end

      local function create_progress_message(request)
        local msg = Message("lsp", "progress")
        local id = request.data.id
        msg.opts.progress = {
          client_id = "client " .. id,
          client = llm_role_title(request.data.adapter),
          id = id,
          message = "Awaiting Response: ",
        }
        return msg
      end

      local function update(message)
        if handles[message.opts.progress.id] then
          Manager.add(Format.format(message, "lsp_progress"))
          vim.defer_fn(function()
            update(message)
          end, ThrottleTime)
        end
      end

      local function finish_progress_message(message)
        Manager.add(Format.format(message, "lsp_progress"))
        Router.update()
        Manager.remove(message)
      end

      local function report_exit_status(request)
        if request.data.status == "success" then
          return " Completed"
        elseif request.data.status == "error" then
          return " Error"
        else
          return "󰜺 Cancelled"
        end
      end

      local group = vim.api.nvim_create_augroup("NoiceCompanionRequests", {})

      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequestStarted",
        group = group,
        callback = function(request)
          local handle = create_progress_message(request)
          store_progress_handle(request.data.id, handle)
          update(handle)
        end,
      })

      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequestFinished",
        group = group,
        callback = function(request)
          local message = pop_progress_message(request.data.id)
          if message then
            message.opts.progress.message = report_exit_status(request)
            finish_progress_message(message)
          end
        end,
      })
    end,
    opts = {
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "gpt-4.1",
                -- default = "claude-3.7-sonnet",
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          keymaps = {
            close = {
              modes = { n = "<C-c>", i = "<C-c>" },
            },
          },
        },
      },
      display = {
        chat = { window = { layout = "float" } },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            show_result_in_chat = true, -- Show mcp tool results in chat
            make_vars = true, -- Convert resources to #variables
            make_slash_commands = true, -- Add prompts as /slash commands
          },
        },
      },
    },
    keys = {
      {
        "<leader>aa",
        function()
          require("codecompanion").toggle()
        end,
        desc = "CodeCompanion Chat",
      },
      {
        "<leader>a:",
        ":CodeCompanion ",
        mode = { "n", "v" },
        desc = "CodeCompanion Chat",
      },
      {
        "<leader>aA",
        "<cmd>CodeCompanionActions<cr>",
        desc = "CodeCompanion Actions",
      },
      {
        "<leader>av",
        "<cmd>CodeCompanionChat Add<cr>",
        mode = "v",
        desc = "Add selection to chat",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
      },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
    config = function()
      require("mcphub").setup()
    end,
  },
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        format = {
          ai_with_visual = {
            pattern = "^:'<,'>CodeCompanion%s+",
            icon = "",
            title = " Code Companion with selection ",
          },
          ai = {
            pattern = "^:CodeCompanion%s+",
            icon = "",
            title = " Code Companion ",
          },
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>a", icon = "", group = "+AI", mode = { "n", "v" } },
      },
    },
  },
}
