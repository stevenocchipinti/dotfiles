local qpreview = function()
  local path = (MiniFiles.get_fs_entry() or {}).path
  if path == nil then
    return vim.notify("Cursor is not on valid entry")
  end
  vim.system({ "qlmanage", "-p", path }, {}, function(result)
    if result.code ~= 0 then
      vim.notify("'qlmanage -p' failed with code: " .. result.code)
      vim.notify("Stderr:\n" .. result.stderr)
    end
  end)
end

return {
  {
    "nvim-mini/mini.pairs",
    enabled = false,
  },
  {
    "nvim-mini/mini.files",
    version = false,
    lazy = false,
    opts = {
      -- g? shows the defaults
      mappings = {
        close = "<ESC>",
        go_in = "L",
        go_in_plus = "l",
      },
      options = {
        permanent_delete = false,
        use_as_default_explorer = true,
      },
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 80,
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Open mini.files (Directory of Current File)",
      },
      {
        "<leader>E",
        function()
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        desc = "Open mini.files (cwd)",
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)

      local show_dotfiles = true
      local filter_show = function(fs_entry)
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require("mini.files").refresh({ content = { filter = new_filter } })
      end

      local map_split = function(buf_id, lhs, direction, close_on_file)
        local rhs = function()
          local new_target_window
          local cur_target_window =
            require("mini.files").get_explorer_state().target_window
          if cur_target_window ~= nil then
            vim.api.nvim_win_call(cur_target_window, function()
              vim.cmd("belowright " .. direction .. " split")
              new_target_window = vim.api.nvim_get_current_win()
            end)

            require("mini.files").set_target_window(new_target_window)
            require("mini.files").go_in({ close_on_file = close_on_file })
          end
        end

        local desc = "Open in " .. direction .. " split"
        if close_on_file then
          desc = desc .. " and close"
        end
        vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
      end

      local files_set_cwd = function()
        local cur_entry_path = MiniFiles.get_fs_entry().path
        local cur_directory = vim.fs.dirname(cur_entry_path)
        if cur_directory ~= nil then
          vim.fn.chdir(cur_directory)
        end
      end

      local map_tab = function(buf_id, lhs)
        local rhs = function()
          local cur_target_window =
            require("mini.files").get_explorer_state().target_window
          if cur_target_window ~= nil then
            vim.api.nvim_win_call(cur_target_window, function()
              vim.cmd("tab split")
            end)
            -- Set new window as target and open
            local new_target_window = vim.api.nvim_get_current_win()
            require("mini.files").set_target_window(new_target_window)
            require("mini.files").go_in({ close_on_file = false })
          end
        end
        vim.keymap.set(
          "n",
          lhs,
          rhs,
          { buffer = buf_id, desc = "Open in new tab" }
        )
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id

           vim.keymap.set(
            "n",
            "K",
            qpreview,
            { buffer = buf_id, desc = "Quick Preview" }
           )

           vim.keymap.set(
            "n",
            "gx",
            function()
              local path = (MiniFiles.get_fs_entry() or {}).path
              if not path then
                vim.notify("Cursor is not on valid entry")
              else
                vim.system({ "open", path })
              end
            end,
            { buffer = buf_id, desc = "Open with system default (gx)" }
           )

          vim.keymap.set(
            "n",
            opts.mappings and opts.mappings.toggle_hidden or "g.",
            toggle_dotfiles,
            { buffer = buf_id, desc = "Toggle hidden files" }
          )

          vim.keymap.set(
            "n",
            opts.mappings and opts.mappings.change_cwd or "gc",
            files_set_cwd,
            { buffer = args.data.buf_id, desc = "Set cwd" }
          )

          map_split(
            buf_id,
            opts.mappings and opts.mappings.go_in_horizontal or "<C-w>s",
            "horizontal",
            false
          )
          map_split(
            buf_id,
            opts.mappings and opts.mappings.go_in_vertical or "<C-w>v",
            "vertical",
            false
          )
          map_split(
            buf_id,
            opts.mappings and opts.mappings.go_in_horizontal_plus or "<C-w>S",
            "horizontal",
            true
          )
          map_split(
            buf_id,
            opts.mappings and opts.mappings.go_in_vertical_plus or "<C-w>V",
            "vertical",
            true
          )
          map_tab(buf_id, "<C-w>t")
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(event)
          Snacks.rename.on_rename_file(event.data.from, event.data.to)
        end,
      })
    end,
  },

  {
    "nvim-mini/mini.surround",
    opts = {
      n_lines = 300,
      mappings = {
        add = "ys",
        delete = "ds",
        replace = "cs",
        -- Not so useful ones
        find = "<localleader>f", --           Find surrounding (to the right)
        find_left = "<localleader>F", --      Find surrounding (to the left)
        highlight = "<localleader>h", --      Highlight surrounding
        update_n_lines = "<localleader>L", -- Update `n_lines`
        suffix_last = "l", --                 Suffix to search with "prev" method
        suffix_next = "n", --                 Suffix to search with "next" method
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "gs", icon = "󰾹", group = "+Surround" },
      },
    },
  },

  {
    "nvim-mini/mini.ai",
    opts = {
      custom_textobjects = {},
    },
  },
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          c = ai.gen_spec.treesitter({ -- comment (was class)
            a = "@comment.outer",
            i = "@comment.inner",
          }),

          k = ai.gen_spec.treesitter({ -- "key"
            a = "@assignment.lhs",
            i = "@assignment.lhs",
          }),

          v = ai.gen_spec.treesitter({ -- "value"
            a = "@assignment.rhs",
            i = "@assignment.rhs",
          }),

          -- Keys and values for CSS
          K = { "^[ ]*().-():" },
          V = { ":[ ]*().-();" },
          r = ai.gen_spec.treesitter({
            a = "@attribute.outer",
            i = "@attribute.inner",
          }),
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "ac", mode = { "o", "x" }, desc = "comment" }, -- Not overriding class for some reason
        { "ic", mode = { "o", "x" }, desc = "comment" }, -- Not overriding class for some reason
        { "ak", mode = { "o", "x" }, desc = "assignment LHS (key)" },
        { "ik", mode = { "o", "x" }, desc = "assignment LHS (key)" },
        { "av", mode = { "o", "x" }, desc = "assignment RHS (value)" },
        { "iv", mode = { "o", "x" }, desc = "assignment RHS (value)" },
        { "ir", mode = { "o", "x" }, desc = "attribute (react, html, etc.)" },
        { "iK", mode = { "o", "x" }, desc = "CSS key" },
        { "aK", mode = { "o", "x" }, desc = "CSS key" },
        { "iV", mode = { "o", "x" }, desc = "CSS value" },
        { "aV", mode = { "o", "x" }, desc = "CSS value" },
      },
    },
  },

  {
    "nvim-mini/mini.align",
    version = false,
    opts = {
      mappings = {
        start = "<localleader>a",
        start_with_preview = "<localleader>A",
      },
    },
  },
}
