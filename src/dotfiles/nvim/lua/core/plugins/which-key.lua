return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    wk.setup({
      icons = {
        breadcrumb = "»", -- symbol used in the command line area
        separator = "➜", -- symbol used between a key and its label
        -- group = "", -- symbol prepended to a group
      },
    })
    wk.add({
      { "<leader>f", group = "file", icon = "" },
    })

    -- Add buffer-local keymaps for file operations
    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "*",
      callback = function(args)
        if vim.bo[args.buf].buftype == "" and vim.fn.bufname(args.buf) ~= "" then
          wk.add({
            buffer = args.buf,
            {
              "<leader>fr",
              function()
                local old_name = vim.fn.expand("%")
                if old_name == "" then
                  print("Not in a file")
                  return
                end
                local new_name = vim.fn.input("New name: ", old_name, "file")
                if new_name ~= "" and new_name ~= old_name then
                  vim.cmd("saveas " .. new_name)
                  vim.cmd("silent !rm " .. old_name)
                  vim.cmd("redraw!")
                end
              end,
              desc = "rename file",
              icon = "",
            },
            {
              "<leader>fc",
              function()
                local old_name = vim.fn.expand("%")
                if old_name == "" then
                  print("Not in a file")
                  return
                end
                local new_name = vim.fn.input("New name: ", old_name, "file")
                if new_name ~= "" and new_name ~= old_name then
                  vim.cmd("saveas " .. new_name)
                end
              end,
              desc = "copy file",
              icon = "",
            },
          })
        end
      end,
    })

    -- Define filetype-specific keybindings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "lua", -- Specify the filetype
      callback = function()
        wk.add({
          --{ "<leader>x", "<CMD>.lua<CR>", buffer = 0, mode = "n", desc = "Execute line" },
          --{ "<leader>x", "<CMD>lua<CR>", buffer = 0, mode = "v", desc = "Execute line" },
        })
      end,
    })
  end,
}
